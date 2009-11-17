require File.dirname(__FILE__) + '/../test_helper'
#require 'test/unit'
require 'socket'
require 'log4r'
require 'log4r/yamlconfigurator'
# we use various outputters, so require them, otherwise config chokes
require 'log4r/outputter/datefileoutputter'
require 'log4r/outputter/emailoutputter'
#require 'lib/mrasp'
#require 'ruby-debug'

class MRASTest < Test::Unit::TestCase
  include Log4r
  cfg = YamlConfigurator # shorthand
  cfg['HOME'] = '.'      # the only parameter in the YAML, our HOME directory
  # load the YAML file with this
  cfg.load_yaml_file('config/log4r.yaml')

=begin 
  # Could it be defined initialize for TestCase?	
	def initialize 
    @log = Logger['MedRuleAgentServerTest']
  end
=end

  def setup
    @log = Logger['MedRuleAgentServerTest']
		@socket = TCPSocket.new('localhost', 1729)
  end

  def teardown
		@socket.close
  end

	def test_usemed
		assert_equal "hello MRAS", @socket.readline.delete("\r\n")
	
		msg = "usemed �D���T�J�ܵo�������`�g��"
		@socket.puts msg
		@log.debug "send usemed"
		result = @socket.readline.delete "\r\n"
		@log.debug "receive #{result}"
		mras = MRASP.new result
    #�w�䬰 req_prop �f�w�౵�����Ī��Ϊk,�s��ϥΤѼ�,�w���e�f,��O����
		assert_equal MRASP::ReqProps, mras.type
		ps = mras.req_props
		#assert_equal "�f�w�౵�����Ī��Ϊk,�s��ϥΤѼ�,�w���e�f,��O����", ps.join(",")
		#debugger
		assert ps.include?("�f�w�౵�����Ī��Ϊk")
		assert ps.include?("�s��ϥΤѼ�")
		assert ps.include?("�w���e�f")
		assert ps.include?("��O����")
	end

	# query syntax and grammer
  # notation: <nonterminal>
	#           terminal
	# syntax: 
	# <query>     := <cmd> <key_value>
	# <cmd>       := get_require_status | is_valid_med
	# <key_value> := <key>:<value>
	# <key>       := <identifier>
	# <value>     := <identifier>
	# <identifier>:= <sletter> + <identifier>
	# <sletter>   := a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|d|w|x|y|z


	def test_hello
		assert_equal "hello MRAS", @socket.readline.delete("\r\n")
	end

  def test_invalid
		assert_equal "hello MRAS", @socket.readline.delete("\r\n")
		msg = "invalid message"
		@socket.puts msg
		@log.debug "send invalid message"
		result = @socket.readline.delete "\r\n"
		mras = MRASP.new result
		assert_equal MRASP::Invalid, mras.type
		assert_equal msg, mras.source
	end


	def test_medstatus
		assert_equal "hello MRAS", @socket.readline.delete("\r\n")
		msg = "med_status ��O����:�D���T�J�ܵo�������`�g��," +
		      "�w���e�f:����,�f�w�౵�����Ī��Ϊk:�`�g,�s��ϥΤѼ�:13"
		@socket.puts msg
		@log.debug "send med_status"
		result = @socket.readline.delete "\r\n"
		@log.debug "receive #{result}"
		mras = MRASP.new result
		assert_equal MRASP::Legality, mras.type
		assert !mras.legal?


		msg = "med_status ��O����:�D���T�J�ܵo�������`�g��," +
		      "�w���e�f:����,�f�w�౵�����Ī��Ϊk:�`�g,�s��ϥΤѼ�:4"

		@socket.puts msg
		@log.debug "send med_status"
		result = @socket.readline.delete "\r\n"
		@log.debug "receive #{result}"
		mras = MRASP.new result
		assert_equal MRASP::Legality, mras.type
		assert mras.legal?
	end
end
