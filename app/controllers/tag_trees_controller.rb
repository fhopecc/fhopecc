class TagTreesController < ApplicationController
  include AuthenticatedSystem

	def index
    redirect_to tag_tree_path('root')
  end

	def load_form
		@tag_tree_yaml = OpenStruct.new
		@tag_tree_yaml.content = current_user.tag_tree.dump_tag_tree
	end

	def load
		tty = params['tag_tree_yaml']
		yaml = tty['content'] + "\r\n"
    current_user.tag_tree.load_from_yaml yaml
    redirect_to tag_tree_path('root')
	end

	def show
		if current_user.tag_tree.nil?
      current_user.create_tag_tree
      current_user.tag_tree.save
		end
		@tag_tree = current_user.tag_tree.find_by_tag(params['id'])
		@tag_tree ||= current_user.tag_tree.root
    respond_to do |format|
      format.html
			format.yml {
        send_data(current_user.tag_tree.root.to_yaml, :filename => "#{current_user.login}_tag_tree.yml" ,:type => 'text/yaml')
			}
		end 

	end

	def new
    @tag_tree = current_user.tag_tree.create_node(params[:tag_tree_id])

    respond_to do |format|
      format.html # new.html.erb
		end 
	end 

	def create
		tp = params['tag_tree']
		@parent = current_user.tag_tree.find_by_tag(tp['parent_id'])
		@parent ||= current_user.tag_tree.root
    @tag_tree = current_user.tag_tree.create_node(@parent.tag)
		@tag_tree.tag = tp['tag']

    respond_to do |format|
      if current_user.tag_tree.save
        flash[:notice] = '建立一個新科目！'
        format.html { 
					redirect_to tag_tree_path(@parent.tag)
				}
      else
        format.html { render :action => "new" }
      end
    end

	end

  def edit
    @tag_tree = current_user.tag_tree.find_by_tag(params[:id])
  end

  def update
		tp = params['tag_tree']
    @tag_tree = current_user.tag_tree.find_by_tag(tp[:id]) 
		@tag_tree.tag = tp['tag']

		unless @tag_tree.isRoot?
			unless tp['parent_id'] == @tag_tree.parent.id
				@current_user.tag_tree.change tp['parent_id'], @tag_tree.tag
			end
		end

    respond_to do |format|
      if current_user.tag_tree.save
        flash[:notice] = '科目已更新！'
        format.html { 
					redirect_to tag_tree_path(@tag_tree)
				}
      else
        format.html { render :action => "edit" }
      end
    end
  end

	def destroy
    @tag_tree = current_user.tag_tree.find_by_tag(params[:id])
		parent = @tag_tree.parent
		@tag_tree.destroy
		current_user.tag_tree.save
    flash[:notice] = '已刪除此科目'
		redirect_to tag_tree_path(parent.name)
	end

end
