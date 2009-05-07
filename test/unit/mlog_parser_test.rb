require File.dirname(__FILE__) + '/../test_helper'
class MlogParserTest < Test::Unit::TestCase
  fixtures :users, :mlogs, :tagtrees

  def assert_eval expect, src, message=nil
    res = @evaluator.run src
    full_message = build_message(message, 
         "<?> should evaluated <?> \nbut was <?>.\n", 
				 src, expect, res)
		assert_block(full_message) do 
			expect == res
		end
	end

	def setup
		@evaluator = MlogEvaluator.new users('quentin'), 30.days.ago, Time.now
	end

	def test_number_literal
		assert_eval 2000, "2000"
		assert_eval 1, "1"
		assert_eval 0, "0"
	end

	def test_number_arithmetic
		assert_eval 2002, "2000 + 2"
		assert_eval 1998, "2000 - 2"
		assert_eval 4000, "2000 * 2"
		assert_eval 1000, "2000 / 2"
  end

  def test_tag_literal
		assert_eval 2000, "醫療費"
    @evaluator.sdate = 61.days.ago
		assert_eval 12040, "醫療費 + 保險費 + 早餐 + 午餐"
  end

	def test_tag_arithmetic
		assert_eval 12000, "醫療費 + 保險費 + 早餐 + 午餐"
		assert_eval 8000, "保險費 - 醫療費"
	end

	def test_tag_hierarchical
		assert_eval 12000, "root"
	end

	def test_tag_mixed_number
		assert_eval 2200, "醫療費 + 200"
		assert_eval 1800, "醫療費 - 200"
		assert_eval 4000, "醫療費 * 2"
		assert_eval 1000, "醫療費 / 2"
	end

	def test_empty
		assert_eval 0, ""
	end

	def test_tag_with_function
		assert_eval 2200, "醫療費.sum + 200"
		assert_eval 2, "醫療費.count"
		assert_eval 1100, "醫療費.max"
		assert_eval 900, "醫療費.min"
		assert_eval 10000, "root.max"
		assert_eval 900, "root.min"
		assert_eval 0, "早餐.min"
	end

end
