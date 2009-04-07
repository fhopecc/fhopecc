require 'tree'
require 'ostruct'

class TagTreeNode < Tree::TreeNode
  alias id name

	def initialize tag
		super object_id
    @content = OpenStruct.new
		self.tag = tag
	end

	def parent_name
		unless parent.nil?
			parent.name
		else
			''
		end
	end

	def content= new_content
		if self.isRoot?
			@content = new_content
		else
			content_was = @content
			should_changes = self.user.mlogs.select do |m| 
				m.tag_list.include? content_was
			end
			should_changes.each do |m|
				m.tag_list.remove content_was
				m.tag_list.add new_content
				m.save
			end
			unless root.find_by_content(new_content).isRoot?
				destroy
			else
				@content = new_content
			end
		end
	end

	def leafs
		self.select do |n|
			n.isLeaf?
		end
	end

	def leafs_contents
		leafs.map do |n|
			n.name
		end
	end

	def child tag
	  detect do |n| n.tag == tag end
	end

	def child_content? *contents
		inject(false) do |memo, node| 
			memo || (contents.include?(node.content))
		end
	end

	def to_s 
		self.tag
	end

	def find_by_content content
		child = detect do |n| n.content == content end
		child ||= self
	end

	def had_content? content
		return !(root.detect {|n| n.content == content}.nil?)
	end

	def destroy
		removeFromParent!
	end

	def dump_tag_tree_file f
		File.open(f, 'w') do |f|
			f << dump_tag_tree
		end
	end

	def dump_tag_tree 
		str = ""
		root.children do |c|
		  c.each do |n|
				str << "  "*(n.parentage.length - 1) << n.tag << ":\n"
		  end 
	  end
		str
	end

	def method_missing m, *args, &block
    @content.send(m, *args, &block)
	end

	def logger
		RAILS_DEFAULT_LOGGER
	end

  class << self
		def parse_tag_tree_file path
      File.open(path) do |f|
        parse_tag_tree f 
      end
		end

		def parse_tag_tree io
			tree = TagTreeNode.new 'root'
			yamltree = YAML::parse(io)
			self._traverse tree, yamltree
			tree
		end

		def _traverse node, yamlnode
			if yamlnode.is_a? YAML::Syck::Map
				yamlnode.value.keys.each do |k|
					children = TagTreeNode.new k.value
					_traverse(children, yamlnode.value[k])
					node << children unless children.nil?
				end
			end
		end
	end

end
