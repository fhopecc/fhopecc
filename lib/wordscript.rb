require 'hpricot'
class Html2Wordscript
	class << self
    def table html
			html = Hpricot.parse html
			rownum = (html/'tr').size
			row  = html%'tr'
			colnum = row.children_of_type('th').size + row.children_of_type('td').size
			out = <<-EOS
cur_table = doc.tables.add selection.range, #{rownum}, #{colnum}
			EOS
			(html/'tr').each_with_index do |tr, tri|
				tr = tr.children_of_type('th') +  tr.children_of_type('td')
        tr.each_with_index do |td, tdi|
					case td.name
					when 'th'
					out << <<-EOS
cur_table.cell(#{tri+1}, #{tdi+1}).range.font.bold = true
					EOS
					else
					out << <<-EOS
cur_table.cell(#{tri+1}, #{tdi+1}).range.font.bold = false
					EOS
					end

					out << <<-EOS
cur_table.cell(#{tri+1}, #{tdi+1}).range.text = ic.iconv('#{td.inner_html}')
					EOS
				end
			end
			out
    end
	end
end
