require File.dirname(__FILE__) + '/../test_helper'
class MlogTokenizerTest < Test::Unit::TestCase
	def assert_has_token symbol_name, value, tokens, message=nil
    full_message = build_message(message, 
         "token<?,?> does not in \n?.\n", symbol_name, value, tokens.to_a.to_s)
		assert_block(full_message) do 
		  t = tokens.detect do |t|
				t.symbol_name == symbol_name && t.value == value
			end
			!t.nil?
		end

	end

  def test_number_literal
		src = "1"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :number_literal, 1, res

		src = "200"
    res = MlogTokenizer.tokenize(src)
	  assert_has_token :number_literal, 200, res

		src = "200 + 1"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :number_literal, 1, res
	  assert_has_token :number_literal, 200, res
	  assert_has_token '+', '+', res
  end


	def test_identifier_with_function
		src = "醫療費.taglist"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :identifier,  "醫療費", res
		assert_has_token :identifier,  "taglist", res
	end
	
	def test_identifier
		src = "醫療費"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :identifier,  "醫療費", res

		src = "醫療費 + 保險費"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :identifier,  "醫療費", res
		assert_has_token :identifier,  "保險費", res
		assert_has_token '+',  '+', res
	end

	def test_tag_mix_number
		src = "醫療費 + 保險費 - 1000"
    res = MlogTokenizer.tokenize(src)
		assert_has_token :identifier, "醫療費", res
		assert_has_token :identifier, "保險費", res
		assert_has_token '+',  '+', res
		assert_has_token '-',  '-', res
		assert_has_token :number_literal, 1000, res
	end

	def test_empty_string
    res = MlogTokenizer.tokenize('')
    assert_has_token "_End_",nil, res
	end

end
