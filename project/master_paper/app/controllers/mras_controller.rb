$:.push '..'
require 'socket'
require 'MRASP'
require 'iconv'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/emailoutputter'

class MrasController < ApplicationController
  include Log4r
  cfg = YamlConfigurator # shorthand
  cfg['HOME'] = '.'      # the only parameter in the YAML, our HOME directory
  cfg.load_yaml_file('config/log4r.yaml')
	PROPNAMEMAP = {
    "�f�w�౵�����Ī��Ϊk" =>"�Ϊk",
    "�w���e�f" =>"�e�f",
    "��O����" => "����",
    "�s��ϥΤѼ�" => "���ĤѼ�"
	}

	def prop_namemap prop
		PROPNAMEMAP[prop] ||= prop
	end


	def index
		render_text "mras protocol"
	end

	def request_test
		render_text request["test"]
	end

	#open and receive hello packet
  def open_conn
		@socket = TCPSocket.new('localhost', 1729)
		@socket.readline.delete("\r\n") # receive hello packet
	end

	def req_props
	  @log = Logger['mrasc']
    require 'iconv'
    @cd = Iconv.new("utf-8", "CP950") #big52utf8
    @cd2 =Iconv.new("CP950", "utf-8") #utf82big5
   
		open_conn

    usemed = @cd2.iconv request["usemed"]
		msg = "usemed " + usemed 
		@socket.puts msg
		result = @socket.readline.delete "\r\n"
		mras = MRASP.new result
		ps = mras.req_props
		unless ps.empty?
			rh =  "<span class='label'>�P�_����<strong class='emphasis'>"
			rh += usemed+"</strong>�X�k�ʻݭn��J�H�U���������A</span>"
		  rh += "<ul>" # result html
		  ps.each do |p|
        rh += "<li>#{prop_namemap(p)}</li>"
		  end
		  rh += "</ul>"

		  render_text @cd.iconv(rh) 
		else
			rh =  "<span class='label'>����<strong class='emphasis'>"
			rh += usemed+"</strong>�L�����������A����</span>"
      #rh += "array="+ps.join(',')
		  render_text @cd.iconv(rh) 
		end
		@socket.close
	end

	def medstatus
	  @log = Logger['mrasc']
    @cd = Iconv.new("utf-8", "CP950") #big52utf8
    @cd2 =Iconv.new("CP950", "utf-8") #utf82big5

		open_conn

    usemed = @cd2.iconv request["usemed"]
		msg = "usemed " + usemed 
		@socket.puts msg
		result = @socket.readline.delete "\r\n"
		mras = MRASP.new result
		ps = mras.req_props # require properties
		pvs = Hash.new # pair value pair
		@log.debug "hash.new"
		nvps = []      # require properties without value pass in
		dict = property_medstatus_map
    ps.each do |p|
			v = @cd2.iconv request[dict[p]] # received value
			if v == nil || v == ""
				nvps.push p # push empty value property into nvps
			else
			  pvs[p]=v
			end
		end
		render_text "test"
		if nvps.empty?
			mras.props=pvs
		  @log.debug "nvps.mras.to_s =" + mras.to_s
			render_legality mras.to_s
		else
      @log.debug "nvps = " + nvps.join(',')
			render_list "�ʤ֥H�U�ݩʡA�иɿ�J!", (nvps.collect do |p| prop_namemap(p) end)
		end
		@socket.close
	end

	def render_legality msg
		@socket.puts msg
		result = @socket.readline.delete "\r\n"
		mras = MRASP.new result
		@log.debug "legality response = " + result
		if mras.legal? 
			res="���ĦX�k�I"
		else
			res="���Ĥ��X�k�I"
		end
	  rh =  "<span class='label'>#{res}</span>"
		render_text @cd.iconv(rh)
	end

  def property_medstatus_map
	  { 
      '�w���e�f'                   => 'disease',
      '�w�f���'                   => 'disease_months',
      '��O����'                   => 'usemed', 
      '�֥��Ī�'                   => 'with_med', 
      '�f�w�౵�����Ī��Ϊk'       => 'usage',  
      '�f�w�i�e�԰Ƨ@�Ϊ��Ī�'     => 'usemed',  
      '�f�w�A�X�Ī�'               => 'usage',  
      '�f�w���a���i'               => 'report',  
		  '�s��ϥΤѼ�'               => 'usedays',
		  '�Ī��ϥΤ���'               => 'patch'
		}
	end

	# render list 
	def render_list title, a
    @cd = Iconv.new("utf-8", "CP950") #big52utf8
	  rh =  "<span class='label'>#{title}</span>"
		rh += "<ul>" # result html
		a.each do |e|
      rh += "<li>#{e}</li>"
		end
		rh += "</ul>"
		render_text @cd.iconv(rh)
	end

end
