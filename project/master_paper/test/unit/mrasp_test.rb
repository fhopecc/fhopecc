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

		@str = 'med_status ノ猭:狝,ぱ计:13,痚痜:'
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
		assert_equal 'ノ猭', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '狝', tok.lexeme
		tok = lex.next
		assert_equal ',', tok.lexeme
		#debugger
		tok = lex.next
		assert_equal 'ぱ计', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '13', tok.lexeme
		tok = lex.next
		assert_equal ',', tok.lexeme
		tok = lex.next
		assert_equal '痚痜', tok.lexeme
		tok = lex.next
		assert_equal ':', tok.lexeme
		tok = lex.next
		assert_equal '', tok.lexeme
	end

	def test_tokens
		str = 'med_status ノ猭:狝,ぱ计:13,痚痜:'
		#debugger
		mrasp = MRASP.new str
		assert_equal 'med_status-ノ猭-:-狝-,-ぱ计-:-13-,-痚痜-:-', 
                 mrasp.tokens.join('-') 
		assert_equal "med_status", mrasp.type 
		assert_equal 'ノ猭-:-狝-,-ぱ计-:-13-,-痚痜-:-', mrasp.data.join('-')
		assert_equal "狝", mrasp.props["ノ猭"]
		assert_equal "13", mrasp.props["ぱ计"]
		assert_equal "", mrasp.props["痚痜"]
	end



  def test_usemed
		str = "usemed 荒警"
		mrasp = MRASP.new(str)
		assert_equal "usemed", mrasp.type
		assert_equal "荒警", mrasp.usemed
	end

  def test_req_prop
		str = "req_props ノ猭,ぱ计,痚痜"
		mrasp = MRASP.new(str)
		assert_equal "req_props", mrasp.type
		assert_equal "ノ猭-ぱ计-痚痜", mrasp.req_props.join("-")

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
		str = "med_status ノ猭:狝,ぱ计:13,痚痜:"
		mrasp = MRASP.new(str)
		assert_equal "med_status", mrasp.type
		assert_equal "狝", mrasp["ノ猭"] 
		assert_equal "13", mrasp["ぱ计"] 
		assert_equal "", mrasp["痚痜"] 
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
		str = "usemed 荒警"
		mrasp = MRASP.new(str)
    assert_equal MRASP::UseMed, mrasp.type
		assert_equal str, mrasp.to_s
		
		str = "req_props ノ猭,ぱ计,痚痜"
		mrasp = MRASP.new(str)
		assert_equal MRASP::ReqProps, mrasp.type
		assert mrasp.to_s.include? "ノ猭"
		assert mrasp.to_s.include? "ぱ计"
		assert mrasp.to_s.include? "痚痜"

		str = "med_status ノ猭:狝,ぱ计:13,痚痜:"
		mrasp = MRASP.new(str)
		assert_equal MRASP::MedStatus, mrasp.type
		assert mrasp.to_s.include? "ノ猭:狝"
		assert mrasp.to_s.include? "ぱ计:13"
		assert mrasp.to_s.include? "痚痜:"

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
