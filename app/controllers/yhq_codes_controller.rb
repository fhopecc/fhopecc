require "csv"
class <<Hash
  def create(keys, values)
    self[*keys.zip(values).flatten]
  end
end

class YhqCodesController < ApplicationController

  def show
		id = params[:id]
		sp_array = Array.new
	 
		first = true
		first_row = []
	 
		CSV.open("db/yhqcode.csv","r") do |row|
			if first
				first = false
				first_row = row.to_a
			else
				result = Hash.create(first_row,row.to_a)
				sp_array << result
			end
		end
		
		@yhqcode = sp_array.detect do |e|
			e["Error Code"] == id
		end
  end

end
