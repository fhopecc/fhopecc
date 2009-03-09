require File.dirname(__FILE__) + '/../test_helper'
require 'wordscript'
class WordscriptTest < ActiveSupport::TestCase
  # Replace this with your real tests.
	def setup
		@htmltable = <<-EOS
<table>
<tr><td>col1</td><td>col2</td></tr>
<tr><td>3</td><td>4</td></tr>
</table>
		EOS

		@wstable = <<-'EOS'
cur_table = doc.tables.add selection.range, 2, 4
cur_table.cell(1, 1).range.text = ic.iconv('col1')
cur_table.cell(1, 2).range.text = ic.iconv('col2')
cur_table.cell(2, 1).range.text = ic.iconv('3')
cur_table.cell(2, 2).range.text = ic.iconv('4')
		EOS
	end
  def test_table
    assert_equal @wstable, Html2Wordscript.table(@htmltable)
  end
end
