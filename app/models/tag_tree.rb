require 'base64'
require 'lib/tag_tree_node'
require 'forwardable'

class TagTree < ActiveRecord::Base
	attr_accessor :root
  extend Forwardable
	def_delegators :@root, *(TagTreeNode.instance_methods - 
		ActiveRecord::Base.instance_methods).map do |m| m.to_sym end
  
  belongs_to  :user

  before_save :save_tag_tree

  def remove parent, node
		parent = child parent
	  node = parent.root.detect do |n| n.name == node end
		node.removeFromParent!
		save
	end
	alias delete remove

	def add parent, node
	  parent = child(parent)
		parent << TagTreeNode.new(node, node)
		save
	end

	def change parent, node
		logger.debug "change node #{parent} to #{node}"
	  parent = find_by_tag(parent)
	  node = find_by_tag(node)
		node.removeFromParent!
		parent << node
		save
	end

	def create_node parent_id
		parent = find_by_tag parent_id
    parent ||= root
		new_node = TagTreeNode.new
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

  def after_initialize 
		yaml = read_attribute(:tag_tree)

		unless yaml.nil?
		  @root =	TagTreeNode.parse_tag_tree(yaml)
		else
	    @root ||= TagTreeNode.parse_tag_tree_file('config/default.tag_tree')
		end

	  @root.tag_tree_id = read_attribute(:id)
	end

	def load_from_yaml yaml
		@root =	TagTreeNode.parse_tag_tree(yaml)
		save
	end

	private
	def save_tag_tree
		write_attribute(:tag_tree, @root.dump_tag_tree)
	end

end
