class HelpersController < ApplicationController
  # GET /helpers/main.xhtml
  def show
		@id = params[:id]
    respond_to do |format|
			format.xhtml {
        render :text => File.open("public/rails_book/#{@id}.xhtml", "r").read
			}
    end
  end

end
