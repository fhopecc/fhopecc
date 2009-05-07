require File.dirname(__FILE__) + '/../test_helper'
class TagTreeNodeTest < Test::Unit::TestCase

	def setup
		@default = TagTreeNode.default
	end

	def test_dynamic_attributes
    t = TagTreeNode.new 'new tag'
		t.new_attr = "new attribute value"
		assert_equal "new attribute value", t.new_attr
	end

	def test_has_tag
		assert @default.hasTag?('收入')
		assert @default.hasTag?('支出')
		assert !@default.hasTag?('不存在')
	end

	def test_tag_as_id
    t = TagTreeNode.new 'root'
		assert_equal 'root', t.id 

		c = TagTreeNode.new 'new tag'
		assert_equal 'new tag', c.id
		t << c
		assert_equal 'new tag', c.id

    c = TagTreeNode.new 'new tag'
		assert_equal 'new tag', c.id
		t << c
		assert_equal '1new tag', c.id

    c = TagTreeNode.new 'new tag'
		assert_equal 'new tag', c.id
		t << c
		assert_equal '2new tag', c.id
	end

	def test_yaml_serialize
		default = 'config/default.tag_tree'
    tree    = TagTreeNode.parse_tag_tree_file(default)
		tree.dump_tag_tree_file default 
    filestr = File.open(default).read
    dumpstr = tree.dump_tag_tree
		assert_equal filestr, dumpstr
	end

end
