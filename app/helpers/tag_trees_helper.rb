module TagTreesHelper
  def tree_view2 tree, function='link'
		tree ||= current_user.tag_tree.root

		output =  "<script type=\"text/javascript\">\n"
		output << "<!--\n"
	  output << "d = new dTree('d');\n"

	  url = tag_tree_path('root')
		
		url = tag_tree_path(tree.parent.tag) unless tree.isRoot?
		output << "d.add(#{tree.hash},-1,'#{tree.tag}','#{url}');\n"

		tree.each do |c|
	    url = tag_tree_path(c.tag)
	    case function
		  when 'selector'
        url = "javascript:$(\\'tag_tree_parent_name\\').value = \\'#{c.tag}\\';$(\\'tag_tree_parent\\').value = \\'#{c.tag}\\';"
			end

			output << "d.add(#{c.hash},#{c.parent.hash},'#{c.tag}','#{url}');\n"
		end
			
	  output << "document.write(d);\n"
		
	  output <<	"//--> \n"
	  output <<	"</script>\n"
	end

	def tree_view tree
		case controller.action_name
		when 'edit'
			tree_selector
		when 'new'
			content_tag :table, draw_row(tree.parent)
		else
			content_tag :table, draw_row(tree)
		end
	end

	def draw_row tree
		output = ''
		unless tree.isRoot?
			output << link_to('父標籤', tag_tree_path(tree.parent.name))
		end
		output << _draw_row(tree)
	end

	def tree_selector
    content_tag :table, _draw_row(current_user.tag_tree, 'selector')
	end

	def _draw_row tree, function='link'
		if tree.isRoot?
			left_tds = 0
		else
		  left_tds = tree.parentage.length
		end
	  
	  link = link_to(tree.tag, tag_tree_path(tree.name))
    case function
		when 'selector'
      link = link_to_function tree.tag, <<-JS
		    $('tag_tree_parent_name').value = '#{tree.tag}';
		    $('tag_tree_parent').value      = '#{tree.tag}';
		  JS
		end

		output = content_tag(:td, ' ')*(left_tds) <<
		content_tag(:td, link) <<
      content_tag(:td, ' ')*(tree.depth - 1)
		output = content_tag(:tr, output)
		tree.children do |c|
			output << _draw_row(c,function)
		end
		return output
	end
end

