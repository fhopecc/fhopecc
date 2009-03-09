require File.dirname(__FILE__) + '/../test_helper'
class MonthTagSummaryTest < ActiveSupport::TestCase
  fixtures :users, :tag_trees, :mlogs

	def setup 
		@mts = MonthTagSummary.find users("quentin"), "200708"
		#tlist = Mlog.tlist(users('quentin'), 30.days.ago, Time.now)
	end

  test "test initialize" do
		mts = MonthTagSummary.find users("quentin"), "200708"
    assert_equal "quentin", mts.user.login
    assert_equal 2007, mts.year
    assert_equal 8, mts.month
  end

  #test "test tlist" do
    #assert_equal 3, Mlog.tlist(users('quentin'), 30.days.ago, Time.now).size
    #assert_equal 4, Mlog.tlist(users('quentin'), 61.days.ago, Time.now).size

		#tlist = Mlog.tlist(users('quentin'), 30.days.ago, Time.now)
		#m = tlist.detect do |m| m.tag == ("保險費") end
		#assert_equal 10000, m.sum.to_i
    #assert_equal 8, mts.month
  #end

end
