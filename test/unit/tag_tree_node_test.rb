require File.dirname(__FILE__) + '/../test_helper'
class TagTreeNodeTest < Test::Unit::TestCase
	def test_dynamic_attributes
    t = TagTreeNode.new 'new tag'
		t.new_attr = "new attribute value"
		assert_equal "new attribute value", t.new_attr
	end

	def test_yaml_serialize
		default = 'config/default.tag_tree'
    filestr = File.open(default).read
    tree    = TagTreeNode.parse_tag_tree_file(default)
    dumpstr = tree.dump_tag_tree
		tree.dump_tag_tree_file default 
		assert_equal filestr, dumpstr
	end
end
