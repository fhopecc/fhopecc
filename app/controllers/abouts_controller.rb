class AboutsController < ApplicationController
  include AuthenticatedSystem
	layout 'mlogs'

	def index
		redirect_to about_url('moneylog')
	end

  def show
		@id = params[:id]
  end

end
