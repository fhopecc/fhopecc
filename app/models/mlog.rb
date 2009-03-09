class Mlog < ActiveRecord::Base
	acts_as_taggable
	belongs_to :user

	def monthly_mlog
	  MonthlyMlog.find_by_mlog self
	end

end
