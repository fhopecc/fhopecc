module MlogsSystem
	def current_month
		year ||=
      session[:year] || Date.today.year
		month||=
      session[:month] || Date.today.month
		@current_month = Date.civil(year.to_i, month.to_i)
	end
end
