require 'strscan'
require 'log4r'
require 'log4r/yamlconfigurator'
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/emailoutputter'
require 'lib/lexer'

class MRASP
  include Log4r
  cfg = YamlConfigurator # shorthand
  cfg['HOME'] = '.'      # the only parameter in the YAML, our HOME directory
  cfg.load_yaml_file('config/log4r.yaml')
  
  UseMed   = 'usemed'
	ReqProps = 'req_props'
	MedStatus= 'med_status'
  Legality = 'legality'
	Invalid  = 'invalid'

  attr_accessor :log, :source, :tokens, :lexer
	attr_accessor :type, :data
  attr_accessor :usemed, :req_props, :props, :legal

  def initialize src
	  @log = Logger['mylogger']
		@log.debug "start logging"
    @source = src
		@req_props = Array.new
		@req_props.clear
		@props = Hash.new # props is property value map
		@legal = false
    @tokens = tokenize @source
		parse @tokens

    @lexer = Lexer do
			identifier '[A-Za-z_]+[A-Za-z0-9_]*'
			number '[0-9]*'
		end

  end

	def [](key)
		return props[key]
	end

	def legal?
		return @legal
	end

	def usemed=(med)
		@usemed = med
    @type   = UseMed
	end

	#props is property value map
	def props=(pvs)
		@props = pvs
    @type  = MedStatus
	end

	def tokenize src
		toks = Array.new
		s = StringScanner.new(src)
		i = 1
    until (s.eos? || i > 100)
			tok = nil
			s.skip(/\s+/)
		  #debugger
      tok = s.scan(/\w+/) if tok.nil?
      tok = s.scan(/[^,:]+/) if tok.nil?
			tok = s.scan(/[,:]/) if tok.nil?
			toks += [tok] unless tok.nil?
			i += 1
		end
		return toks
	end

	def parse toks
		#log.debug "start parse"
		cur_tok_pointer = 0
    @type=toks[cur_tok_pointer]
		#log.debug "type is #{@type}"
		cur_tok_pointer += 1
		@data=toks.values_at(1..(toks.length-1))

		if @type == UseMed
      @usemed = toks[cur_tok_pointer]
		elsif @type == ReqProps
      prop_list toks, cur_tok_pointer
		elsif @type == MedStatus
		  #log.debug "test log"
      prop_val_pair_list toks, cur_tok_pointer
		elsif @type == Legality
			#log.debug "legality = #{toks[cur_tok_pointer]}"
			@legal = (toks[cur_tok_pointer] == 'true')
		else
			@type = Invalid
		end
	end 

	def prop_list toks, cur_tok_pointer
		return cur_tok_pointer if toks[cur_tok_pointer] == nil
    @req_props << toks[cur_tok_pointer]
		cur_tok_pointer += 1
    if toks[cur_tok_pointer] == ','
			cur_tok_pointer += 1
			cur_tok_pointer = prop_list toks, cur_tok_pointer
		end
		return cur_tok_pointer
	end

	def prop_val_pair_list toks, cur_tok_pointer
		#log.debug "test log2"
    cur_tok_pointer = prop_val_pair toks, cur_tok_pointer
    if toks[cur_tok_pointer] == ','
			cur_tok_pointer += 1
			cur_tok_pointer = prop_val_pair_list toks, cur_tok_pointer
	  end
		return cur_tok_pointer
	end

	def prop_val_pair toks, cur_tok_pointer
    prop = toks[cur_tok_pointer]
		#log.debug "prop=#{prop}"
	  cur_tok_pointer += 2
    val = toks[cur_tok_pointer]
		log.debug "val=#{val}"
		props[prop]=val
		cur_tok_pointer += 1
		return cur_tok_pointer
	end

	def to_s
		case @type
			when UseMed
		    return "usemed "+usemed
			when ReqProps
			  return "req_props " + @req_props.join(',');
			when MedStatus
				psa = Array.new # pair string array
				@props.each do |k, v|
				  psa.push "#{k}:#{v}"
				end
				return "med_status " + psa.join(',')
			when Legality
				return "legality " + (if legal?() then "true" else "false" end)
	    else
		    return "invalid " + @source;
		end
	end

end
