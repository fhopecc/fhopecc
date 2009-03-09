require 'base64'
require 'tree'
def tag_tree_string
	r =  Tree::TreeNode.new("root", "root")
	r << Tree::TreeNode.new("醫療費", "醫療費")
	r << Tree::TreeNode.new("保險費", "保險費")
	r << Tree::TreeNode.new("旅費", "旅費") << Tree::TreeNode.new("住宿費", "住宿費")
	r << Tree::TreeNode.new("餐飲費", "餐飲費") << Tree::TreeNode.new("午餐", "午餐")
	d = Base64.encode64(Marshal.dump(r)) 
end
Content = <<EOS
one:
  id: 1
  user_id: 1
  tag_tree: "#{tag_tree_string}"

two:
  id: 2
EOS

namespace "tag_tree" do
	desc "make fixture"
	task :make_fixture do
		File.open 'test/fixtures/tag_trees.yml', 'w' do |f|
			f << Content
		end
	end
end
