require File.dirname(__FILE__) + '/../test_helper'
class TagTreeTest < Test::Unit::TestCase
  fixtures :users, :tag_trees

  def test_attributes
		assert_equal 1, tag_trees(:one).user_id
    assert_equal "quentin", tag_trees(:one).user.login 
		r2 = Marshal.restore(Base64.decode64(tag_trees(:one).tag_tree))
		assert_equal "root", r2.name
		assert_equal "醫療費", r2.firstChild.name
  end

	def test_root
		assert_equal "root", tag_trees(:one).root.name
	end

  def test_forwardable
		assert_equal "root", tag_trees(:one).name
	end

	def test_child
		assert_equal "root", tag_trees(:one).child("root").name
		assert_equal "住宿費", tag_trees(:one).child('旅費').firstChild.name
		tag_trees(:one).child('保險費') << Tree::TreeNode.new("醫療險", "醫療險")
		assert_equal "醫療險", tag_trees(:one).child('保險費').firstChild.name
  end

	def test_user_create_tag_tree
		u = User.new
		u.save
    if u.tag_tree.nil?
			u.create_tag_tree
		end
		assert_equal 'root', u.tag_tree.root.name
	end

	def test_save_tag_tree
    tag_trees(:one).root << Tree::TreeNode.new("child3", "child3content")
    t = User.find_by_login('quentin').tag_tree
		assert t.child('child3').nil?

		tag_trees(:one).save
    t = User.find_by_login('quentin').tag_tree
		assert_equal "child3content", tag_trees(:one).child('child3').content
	end

	def test_association
		t = TagTree.new 
		t.user_id = User.find_by_login('quentin').id
		t.save
    assert_equal "quentin", t.user.login
	end

  def test_default_tag_tree
		t = TagTree.new
		assert_equal "root", t.root.name
	end

	def test_each_leaf
		tag_trees(:one).each_leaf do |e|
		  assert ["醫療費", "保險費", "住宿費", "午餐"].member?(e.name)
		end
	end

  def test_leafs
		assert_equal Set["醫療費", "保險費", "住宿費", "午餐"], Set.new(tag_trees(:one).leafs.map{|n|n.name})
	end
end
