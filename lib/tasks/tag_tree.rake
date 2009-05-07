module Tree 
	class TreeNode
		def dump_tag_tree_file f
			File.open(f, 'w') do |f|
				f << dump_tag_tree
			end
		end

		def dump_tag_tree 
			str = ""
			root.children do |c|
				c.each do |n|
					str << "  "*(n.parentage.length - 1) << n.content << ":\n"
				end 
			end
			str
		end
	end
end

namespace "tag_tree" do
	desc "make fixture"
	task :make_fixture do
		File.open 'test/fixtures/tag_trees.yml', 'w' do |f|
			f << Content
		end
	end

	task :export_old_tagtree do 
    tree = User.find_by_login('fhopecc').tag_tree
		tree.dump_tag_tree_file 'config\fhopecc.tagtree'
    tree = User.find_by_login('joan').tag_tree
		tree.dump_tag_tree_file 'config\joan.tagtree'
    tree = User.find_by_login('jone').tag_tree
		tree.dump_tag_tree_file 'config\jone.tagtree'
	end
end
