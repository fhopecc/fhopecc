# Methods added to this helper will be available to all templates in the application.
require 'ostruct'
module ApplicationHelper

	def browser
		browser = OpenStruct.new
		case controller.request.user_agent
		when /MSIE/
			browser.agent = 'MSIE'
		else
			browser.agent = 'Mozilla'
			browser.version = '5.0'
		end
		browser
	end

	def css_link_tag
		if browser.agent == 'MSIE'
			stylesheet_link_tag 'mlog_ie'
		else
			stylesheet_link_tag 'mlog'
		end
	end

	def common_task label, task
		task = task.pluralize
		cls  = "task"
    if current_task? task
      cls = "current_task"
		end
    link_to label, self.send("#{task}_url"), :class => cls
	end

	def current_task? task
    task.pluralize == current_task
	end

	def current_task
    controller.class.name.gsub('Controller','').underscore 
	end

	def monthly_task label, task
		task = "monthly_#{task}"
		path = "#{task.singularize}_url".to_sym
		cls = "task"
    if current_task? task
      cls = "current_task"
		end
		id = Date.today.year.to_s + Date.today.month.to_s.rjust(2,'0')
		id = @mmlog.id unless @mmlog.nil?
	 	link_to label, 
		   self.send(path, id), :class => cls
	end

	def month_button mon 
		task = current_task
		path = "#{task.singularize}_url".to_sym
		cls  = "mon"
		if mon == @mmlog.month
      cls = "current_mon"
		end
		link_to mon.strftime("%Y-%m"), 
			self.send(path, mon.year.to_s + mon.month.to_s.rjust(2, '0')), 
			{:class => cls}
	end

  def tag_button tag
		target = controller.class.name
		#link = link_to_function "#{tag}(#{tag.count})", <<-JS
		link = link_to_function tag, <<-JS
		    if($F('mlog_tag_list').length == 0)
				  $('mlog_tag_list').value = '#{tag}'
		    else
				  $('mlog_tag_list').value = $F('mlog_tag_list') +', #{tag}'
		    end
			JS

		case target
		when 'TagTreesController'
			link = link_to_function tag, <<-JS
				$('tag_tree_content').value = '#{tag}'
			JS
		end
		link
	end

	def tag_select obj, method
		tags = current_user.tagtree.leafs.map{|l|l.name}
		select obj, method, tags
	end

	def extract str, show_length=20, etc = '...'
		return str if  str.length < show_length
		str[0, show_length] << etc
	end

	def link_to_submit title 
    link_to_function title, "$(this).up('form').submit()"
	end
  
	def link_to_help title
    link_to title, '/mlogman/main.xhtml'
	end
end

