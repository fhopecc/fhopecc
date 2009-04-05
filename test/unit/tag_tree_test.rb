require File.dirname(__FILE__) + '/../test_helper'
class TagTreeTest < Test::Unit::TestCase
  fixtures :users, :tag_trees

  def test_default_tag_tree
		t = TagTree.new
		assert_equal "root", t.root.tag
		assert_equal TagTreeNode, t.child('月薪').class
		assert !t.child('月薪').nil?
		assert_equal nil, t.child('不存在的標籤')
	end

	def test_user_association
		t = TagTree.new 
		t.user_id = User.find_by_login('quentin').id
		t.save
    assert_equal "quentin", t.user.login
	end

	def test_tag_tree_node_association
		t = TagTree.new 
		t.user_id = User.find_by_login('quentin').id
		t.save
		tree = User.find_by_login('quentin').tag_tree
		assert !tree.child('支出').nil
		assert_equal nil, tree.child('不存在的標籤')
	end

	def test_tree_operation
		t = User.find_by_login('quentin').create_tag_tree
    t << TagTreeNode.new("new tag")
		assert !t.child('new tag').nil?
		t.save
		t = User.find_by_login('quentin').tag_tree
		assert !t.child('new tag').nil?
	end

  def test_forwardable
		assert_equal "root", tag_trees(:one).root.tag
	end

=begin
  def test_attributes
		assert_equal 1, tag_trees(:one).user_id
    assert_equal "quentin", tag_trees(:one).user.login 
		r2 = Marshal.restore(Base64.decode64(tag_trees(:one).tag_tree))
		assert_equal "root", r2.name
		assert_equal "醫療費", r2.firstChild.name
  end


	def test_user_create_tag_tree
		u = User.new
		u.save
    if u.tag_tree.nil?
			u.create_tag_tree
		end
		assert_equal 'root', u.tag_tree.root.name
	end




	def test_each_leaf
		tag_trees(:one).each_leaf do |e|
		  assert ["醫療費", "保險費", "住宿費", "午餐"].member?(e.name)
		end
	end

  def test_leafs
		assert_equal Set["醫療費", "保險費", "住宿費", "午餐"], Set.new(tag_trees(:one).leafs.map{|n|n.name})
	end
=end
end
