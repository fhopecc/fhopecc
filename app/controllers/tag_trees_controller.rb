class TagTreesController < ApplicationController
  include AuthenticatedSystem

	def index
    redirect_to tag_tree_path('root')
  end

	def show
		if current_user.tag_tree.nil?
      current_user.create_tag_tree
      current_user.tag_tree.save
		end
		@tag_tree = current_user.tag_tree.child(params['id'])
    respond_to do |format|
      format.html
			format.yml {
        send_data(current_user.tag_tree.root.to_yaml, :filename => "#{current_user.login}_tag_tree.yml" ,:type => 'text/yaml')
			}
		end 

	end

  def edit
    @tag_tree = current_user.tag_tree.child(params[:id])
  end

	def new
		parent = params[:tag_tree_id]
    @tag_tree = current_user.tag_tree.create_node(parent)

    respond_to do |format|
      format.html # new.html.erb
		end 
	end 

	def create
		tp = params['tag_tree']
    @tag_tree = current_user.tag_tree.create_node(tp['parent_name'])
		@tag_tree.content = tp['content']

    respond_to do |format|
      if current_user.tag_tree.save
        flash[:notice] = '建立一個新科目！'
        format.html { 
					parent = 'root' if @tag_tree.parent.nil?
					redirect_to tag_tree_path(parent)
				}
      else
        format.html { render :action => "new" }
      end
    end

	end

  def update
    @tag_tree = current_user.tag_tree.child(params[:id])

		tp = params['tag_tree']
		@tag_tree.content = tp['content']

		unless @tag_tree.isRoot?
			unless tp['parent_id'] == @tag_tree.parent.name
				@current_user.tag_tree.change tp['parent_name'], params[:id]
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
    @tag_tree = current_user.tag_tree.child(params[:id])
		parent = @tag_tree.parent
		@tag_tree.destroy
		current_user.tag_tree.save
    flash[:notice] = '已刪除此科目'
		redirect_to tag_tree_path(parent.name)
	end

end
