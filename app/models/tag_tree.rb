require 'base64'
require 'tree'
require 'forwardable'

module Tree 
	class TreeNode
		def logger
			RAILS_DEFAULT_LOGGER
		end
		def parent_name
      unless parent.nil?
				parent.name
			else
				''
			end
		end

  	def leafs
			self.select do |n|
				n.isLeaf?
			end
	  end

		def leafs_contents
			leafs.map do |n|
				n.content
			end
		end

		def child_content? *contents
			inject(false) do |memo, node| 
				memo || (contents.include?(node.content))
			end
		end

		def to_s 
			content.to_s
		end

	  def find_by_content content
			child = detect do |n| n.content == content end
			child ||= self
	  end

		def user
			User.find_by_login(root.content)
		end

		def tag_tree
			user.tag_tree
		end

		def destroy
		  removeFromParent!
		end

	end
end

class TagTree < ActiveRecord::Base
	belongs_to  :user
  before_save :save_tag_tree
  extend Forwardable
	def_delegators :@root, *(Tree::TreeNode.instance_methods - 
		ActiveRecord::Base.instance_methods).map do |m| m.to_sym end
  
	attr_accessor :root

  def after_initialize 
		tt = read_attribute(:tag_tree)
		logger.debug 'tag_tree ' + tt.to_s
		unless tt.nil?
		  @root =	Marshal.restore(Base64.decode64(tt)) 
		end
	  @root ||= create_default_tree
		save
	end

	def create_default_tree
		user    = User.find(user_id)
    root    =  Tree::TreeNode.new("root", user.login)
    expense =  Tree::TreeNode.new("a", "支出")
    expense << Tree::TreeNode.new("b", "食")
    expense << Tree::TreeNode.new("c", "衣")
    expense << Tree::TreeNode.new("d", "住")
    expense << Tree::TreeNode.new("e", "行")
    expense << Tree::TreeNode.new("f", "育")
    expense << Tree::TreeNode.new("g", "樂")
    expense << Tree::TreeNode.new("h", "家用")
    expense << Tree::TreeNode.new("i", "孝親")
		income  =  Tree::TreeNode.new("j", "收入")
    income  << Tree::TreeNode.new("k", "月薪")
    income  << Tree::TreeNode.new("l", "年終獎金")
    income  << Tree::TreeNode.new("m", "意外財")
    fexpen  =  Tree::TreeNode.new("i", "固定支出")
    fexpen  << Tree::TreeNode.new("j", "保姆費")
    fexpen  << Tree::TreeNode.new("k", "房租")
		credit  =  Tree::TreeNode.new("n", "信用卡")
    root << expense
		root << income
		root << credit 
		root
	end


	#def tag_tree
	#	t = read_attribute(:tag_tree)
	#	if t.nil? or t.empty?
	#		r = create_default_tree
	#		t = Base64.encode64(Marshal.dump(r))
	#		write_attribute(:tag_tree,t) 
	#	  save
	#	end
	#	t
	#end

  def remove parent, node
		parent = child parent
	  node = parent.root.detect do |n| n.name == node end
		node.removeFromParent!
		save
	end
	alias delete remove

	def add parent, node
	  parent = child(parent)
		parent << Tree::TreeNode.new(node, node)
		save
	end

	def change parent, node
		logger.debug "change node #{parent} to #{node}"
	  parent = child(parent)
	  node = child(node)
		node.removeFromParent!
		parent << node
		save
	end

	def rename old_node, new_node
	  old_node = child(parent)
		parent   = old_node.parent
		new_node = Tree::TreeNode.new(new_node, new_node) 
		parent << new_node
		old_node.children() do |c|
			c.removeFromParent!
      new_node << c
		end
		old_node.removeFromParent!
		save
	end

	def child name
	  child = @root.detect do |n| n.name == name end
		child ||= @root
	end


	def create_node parent
		parent = child parent
		new_node = Tree::TreeNode.new(sequence, '新科目') 
		parent << new_node
		new_node
	end

	def each_leaf &proc
		@root.each_leaf &proc
	end

	def leafs
		root.select do |n|
			n.isLeaf?
		end
	end

	def sequence
		old = read_attribute(:sequence)
		write_attribute(:sequence, old + 1)
		old.to_s
	end

	private
	def save_tag_tree
		d = Base64.encode64(Marshal.dump(@root))
		write_attribute(:tag_tree,d) 
	end
end
