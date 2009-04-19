class MlogsController < ApplicationController
  include AuthenticatedSystem
  include MlogsSystem
  before_filter :login_required
	
  def index
		@mlogs = Mlog.find :all
  end

  def show
    @mlog = Mlog.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mlog }
    end
  end

  def new
		year   = params[:year]
		month  = params[:month]
    now = TZInfo::Timezone.get('Asia/Taipei').utc_to_local(Time.now.utc)
		year  ||= now.year
		month ||= now.month
    day     = now.day
		@default_date = Date.civil year.to_i, month.to_i, day

    @mlog = current_user.mlogs.build
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @mlog }
    end
  end

  # GET /mlogs/1/edit
  def edit
    @mlog = Mlog.find(params[:id])
  end

  # GET /mlogs/1/help
  def help
    respond_to do |format|
			format.xhtml
	  end
  end

  # POST /mlogs
  # POST /mlogs.xml
  def create
    @mlog = Mlog.new(params[:mlog])

    respond_to do |format|
      if @mlog.save
        flash[:notice] = '入帳成功！'
        format.html { 
					redirect_to monthly_mlog_path(@mlog.monthly_mlog.id)
				
				}
        format.xml  { render :xml => @mlog, :status => :created, :location => @mlog }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @mlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /mlogs/1
  # PUT /mlogs/1.xml
  def update
    @mlog = Mlog.find(params[:id])

    respond_to do |format|
      if @mlog.update_attributes(params[:mlog])
				unless params[:transfer_user].nil? 
					tuser = User.find_by_login(params[:transfer_user])
					unless tuser.nil?
						@mlog[:user_id] = tuser.id
						@mlog.save
					end
				end

        flash[:notice] = '改帳成功！'
        format.html { 
					redirect_to monthly_mlog_path(@mlog.monthly_mlog.id)
				}
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @mlog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /mlogs/1
  # DELETE /mlogs/1.xml
  def destroy
    @mlog = Mlog.find(params[:id])
    @mlog.destroy

    respond_to do |format|
      format.html { 
			  redirect_to monthly_mlog_path(@mlog.monthly_mlog.id)
      }
      format.xml  { head :ok }
    end
  end
end
