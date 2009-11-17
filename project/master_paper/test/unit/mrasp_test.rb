require File.dirname(__FILE__) + '/../test_helper'
#require 'test/unit'
require 'ruby-debug'
#require 'lexer'
require 'lib/lexer'
require 'lib/mrasp'

class MRASPTest < Test::Unit::TestCase

	def setup
    @lexer = Lexer do
			identifier '[^,: ]+'
			comma  ','
			colon  ':'
		end

		@str = 'med_status �Ϊk:�f�A,����Ѽ�:13,�e�f:����'
	end

	def test_lexer
    lex = @lexer
		lex.read @str
		assert !lex.end?
		tok = lex.next
		assert_equal 'med_status', tok.lexeme
		assert_equal :identifier, tok.type
		assert !lex.end?
		tok = lex.next
		assert_equal '�Ϊk', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '�f�A', tok.lexeme
		tok = lex.next
		assert_equal ',', tok.lexeme
		#debugger
		tok = lex.next
		assert_equal '����Ѽ�', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '13', tok.lexeme
		tok = lex.next
		assert_equal ',', tok.lexeme
		tok = lex.next
		assert_equal '�e�f', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '����', tok.lexeme
	end

	def test_tokens
		str = 'med_status �Ϊk:�f�A,����Ѽ�:13,�e�f:����'
		#debugger
		mrasp = MRASP.new str
		assert_equal 'med_status-�Ϊk-:-�f�A-,-����Ѽ�-:-13-,-�e�f-:-����', 
                 mrasp.tokens.join('-') 
		assert_equal "med_status", mrasp.type 
		assert_equal '�Ϊk-:-�f�A-,-����Ѽ�-:-13-,-�e�f-:-����', mrasp.data.join('-')
		assert_equal "�f�A", mrasp.props["�Ϊk"]
		assert_equal "13", mrasp.props["����Ѽ�"]
		assert_equal "����", mrasp.props["�e�f"]
	end



  def test_usemed
		str = "usemed ��ľ�"
		mrasp = MRASP.new(str)
		assert_equal "usemed", mrasp.type
		assert_equal "��ľ�", mrasp.usemed
	end

  def test_req_prop
		str = "req_props �Ϊk,����Ѽ�,�e�f"
		mrasp = MRASP.new(str)
		assert_equal "req_props", mrasp.type
		assert_equal "�Ϊk-����Ѽ�-�e�f", mrasp.req_props.join("-")

		str = "req_props "
		mrasp = MRASP.new(str)
		assert_equal "req_props", mrasp.type
		mrasp.req_props.each do |a|
			assert mrasp.req_props.length > 1
			assert !mrasp.req_props.empty?
			assert_not_nil a
			flunk "a = " + a
		end
	  assert mrasp.req_props.length == 0
		assert mrasp.req_props.empty?
	end

  def test_medstatus
		str = "med_status �Ϊk:�f�A,����Ѽ�:13,�e�f:����"
		mrasp = MRASP.new(str)
		assert_equal "med_status", mrasp.type
		assert_equal "�f�A", mrasp["�Ϊk"] 
		assert_equal "13", mrasp["����Ѽ�"] 
		assert_equal "����", mrasp["�e�f"] 
	end

  def test_legality
		str = "legality true"
		mrasp = MRASP.new(str)
		assert_equal mrasp.type, "legality"
		assert mrasp.legal?
	end

	def test_invalid
		str = "invalid message"
		mrasp = MRASP.new str
		assert_equal MRASP::Invalid, mrasp.type
		assert_equal str, mrasp.source
	end
	def test_to_s
		str = "usemed ��ľ�"
		mrasp = MRASP.new(str)
    assert_equal MRASP::UseMed, mrasp.type
		assert_equal str, mrasp.to_s
		
		str = "req_props �Ϊk,����Ѽ�,�e�f"
		mrasp = MRASP.new(str)
		assert_equal MRASP::ReqProps, mrasp.type
		assert mrasp.to_s.include? "�Ϊk"
		assert mrasp.to_s.include? "����Ѽ�"
		assert mrasp.to_s.include? "�e�f"

		str = "med_status �Ϊk:�f�A,����Ѽ�:13,�e�f:����"
		mrasp = MRASP.new(str)
		assert_equal MRASP::MedStatus, mrasp.type
		assert mrasp.to_s.include? "�Ϊk:�f�A"
		assert mrasp.to_s.include? "����Ѽ�:13"
		assert mrasp.to_s.include? "�e�f:����"

		str = "legality true"
		mrasp = MRASP.new(str)
		assert_equal MRASP::Legality, mrasp.type
		assert_equal str, mrasp.to_s

		str = "invalid message"
		mrasp = MRASP.new str
		assert_equal MRASP::Invalid, mrasp.type
		assert_equal "invalid " + str, mrasp.to_s

	end
end
