class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
	layout proc {|c| c.action_name == 'new' ? 'session' : 'users'}

	def index
		if (!current_user.nil? and current_user.login == 'fhopecc')
			@users = User.find :all
			@users = @users.sort_by{|u| u.mlogs.size}
		end
	end

	def show
    @user = User.find(params[:id])
	end

  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save
    if @user.errors.empty?
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Thanks for signing up!"
    else
      render :action => 'new'
    end
  end

end
