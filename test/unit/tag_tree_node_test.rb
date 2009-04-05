require File.dirname(__FILE__) + '/../test_helper'
class TagTreeNodeTest < Test::Unit::TestCase
	def test_dynamic_attributes
    t = TagTreeNode.new
		t.new_attr = "new attribute value"
		assert_equal "new attribute value", t.new_attr
	end

	def test_parse_file
    tree = YAML::parse_file('config/default.tag_tree')
		puts tree.emitter.class.name
	end
end
