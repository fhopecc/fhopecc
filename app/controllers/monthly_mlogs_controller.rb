class MonthlyMlogsController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
	layout 'monthly'
	
  def index
		redirect_to monthly_mlog_path(Date.today.month)
  end

  def show
    @mmlog = current_user.monthly_mlogs.find(params[:id])
    respond_to do |format|
      format.html 
    end
  end

end
