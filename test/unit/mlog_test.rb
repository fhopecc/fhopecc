require File.dirname(__FILE__) + '/../test_helper'
class MlogTest < Test::Unit::TestCase
  fixtures :users, :tag_trees, :mlogs
  # Replace this with your real tests.
  def test_mlog_tlist
    assert_equal 3, Mlog.tlist(users('quentin'), 30.days.ago, Time.now).size
    assert_equal 4, Mlog.tlist(users('quentin'), 61.days.ago, Time.now).size

		tlist = Mlog.tlist(users('quentin'), 30.days.ago, Time.now)
		m = tlist.detect do |m| m.tag == ("保險費") end
		assert_equal 10000, m.sum.to_i
  end

	def test_tagsum
    assert_equal 12000, Mlog.tagsum(users('quentin'), 30.days.ago, Time.now, "root")
    assert_equal 12040, Mlog.tagsum(users('quentin'), 61.days.ago, Time.now, "root")
    assert_equal 2000, Mlog.tagsum(users('quentin'), 30.days.ago, Time.now, "醫療費")
    assert_equal 0, Mlog.tagsum(users('quentin'), 30.days.ago, Time.now, "早餐")
	end

end
