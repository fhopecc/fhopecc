class MonthlyTaglistsController < ApplicationController
  include AuthenticatedSystem
  before_filter :login_required
	layout 'monthly'

  # GET /month_tag_summaries
  # GET /month_tag_summaries.xml
  def index
    @month_tag_summaries = MonthTagSummary.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @month_tag_summaries }
    end
  end

  # GET /month_tag_summaries/1
  # GET /month_tag_summaries/1.xml
  def show
    @mmlog = current_user.monthly_mlogs.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @mmlog }
    end
  end

  # GET /month_tag_summaries/new
  # GET /month_tag_summaries/new.xml
  def new
    @month_tag_summary = MonthTagSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @month_tag_summary }
    end
  end

  # GET /month_tag_summaries/1/edit
  def edit
    @month_tag_summary = MonthTagSummary.find(params[:id])
  end

  # POST /month_tag_summaries
  # POST /month_tag_summaries.xml
  def create
    @month_tag_summary = MonthTagSummary.new(params[:month_tag_summary])

    respond_to do |format|
      if @month_tag_summary.save
        flash[:notice] = 'MonthTagSummary was successfully created.'
        format.html { redirect_to(@month_tag_summary) }
        format.xml  { render :xml => @month_tag_summary, :status => :created, :location => @month_tag_summary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @month_tag_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /month_tag_summaries/1
  # PUT /month_tag_summaries/1.xml
  def update
    @month_tag_summary = MonthTagSummary.find(params[:id])

    respond_to do |format|
      if @month_tag_summary.update_attributes(params[:month_tag_summary])
        flash[:notice] = 'MonthTagSummary was successfully updated.'
        format.html { redirect_to(@month_tag_summary) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @month_tag_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /month_tag_summaries/1
  # DELETE /month_tag_summaries/1.xml
  def destroy
    @month_tag_summary = MonthTagSummary.find(params[:id])
    @month_tag_summary.destroy

    respond_to do |format|
      format.html { redirect_to(month_tag_summaries_url) }
      format.xml  { head :ok }
    end
  end
end
