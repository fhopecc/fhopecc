require 'ostruct'
class MonthlyMlog
	attr_accessor :user, :year, :month
	class << self
		def find_by_user_and_mon user, mon
		  year = Date.today.year
		  month = mon
			if mon.length == 6 then
				year = mon[0..3]
				month = mon[4..5]
			end
			new user, year, month
		end

		def find_by_mlog mlog
			mon = mlog.date.year.to_s + mlog.date.month.to_s.rjust(2, '0') 
      find_by_user_and_mon mlog.user, mon
		end
	end

	def id
    @year.to_s + @month.to_s.rjust(2, '0') 
	end

	def month
		Date.civil @year.to_i, @month.to_i
	end

	def initialize user, year, mon
    @user, @year, @month = user, year.to_i, mon.to_i
		@sdate = Date.civil @year, @month
		@edate = (@sdate >> 1) - 1
	end
  
	def mlogs
  	@user.mlogs.find :all, 
			        :conditions => [ "date BETWEEN ? AND ? ", @sdate, @edate], 
				      :order => "date DESC"	
  end

  def list
		ms = mlogs
		leafs = @user.tag_tree.leafs.map{|l| l.content}
	  ts = ms.group_by { |m| (m.tag_list & leafs)[0] }
		ts.keys.map do |k| 
			OpenStruct.new({:tag   => k, 
										  :count => ts[k].size, 
										  :sum   => ts[k].sum {|m| m.value}})
		end
	end

  def taglist
		ms = mlogs
		leafs = @user.tag_tree.leafs.map{|l| l.content}
	  ts = ms.group_by { |m| (m.tag_list & leafs)[0] }
		ts.keys.map do |k| 
			OpenStruct.new({:tag   => k, 
										  :count => ts[k].size, 
										  :sum   => ts[k].sum {|m| m.value}})
		end
	end

  def logger
		RAILS_DEFAULT_LOGGER
  end

	def in_tag tag
		tree = @user.tag_tree.find_by_content(tag)
    ms = mlogs.select do |t| 
			tree.child_content? *(t.tag_list)
	  end
	  ts = ms.group_by do |m| 
			(m.tag_list & tree.leafs_contents)[0] 
		end

		ts.keys.map do |k|
			OpenStruct.new({:tag   => k, 
										  :count => ts[k].size, 
										  :sum   => ts[k].sum {|m| m.value}})
		end.sort_by {|t| t.sum*(-1)}
	end

	def expense
		in_tag('支出')
	end

	def expense_sum
		expense.sum {|e| e.sum}
	end

	def fexpense
		in_tag('固定支出')
	end

	def fexpense_sum
		fexpense.sum {|e| e.sum}
	end



	def income
		in_tag('收入')
	end

	def income_sum
		income.sum {|e| e.sum}
	end

	def balance
		income_sum - expense_sum
	end

end
