module DbaHelper
	def boolean_cell
    '<td style="font-size:9pt">□ 正常<br/>' + "\n" + "□ 異常</td>"
	end

	def season_start_month mon 
		((mon-1) / 3)*3 +  1
	end

	def friday_date date
		(date + (4-date.wday))
	end
end
