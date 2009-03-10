#ENV["RAILS_ENV"] = "dev"
require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
class Mlogv1Base < ActiveRecord::Base
  self.abstract_class = true
  #establish_connection "mlogv1"
end

class Mlogv1 < Mlogv1Base
	set_table_name 'mlogs'
end

class TagTreeV1 < Mlogv1Base
	set_table_name 'tagtrees'
end

namespace 'legacy' do
	task :import_mlog do
		joan = User.find_by_login 'joan'
    mlogv1s = Mlogv1.find :all   
    mlogv1s.each do |mv1|
			m = Mlog.new :user_id => joan.id, :value => mv1.value, 
			             :date => mv1.date, :comment => mv1.comment
			m.tag_list =  mv1.tag
      m.save
		end		
	end

	task :import_tagtree do
		TagTree.find(:all).each do |t|
			tv1 = TagTreeV1.find(1)
			#puts tv1.tagtree
			t.root = Marshal.restore(Base64.decode64(tv1.tagtree))
			puts t.tag_tree
			t.save
		end
	end
end
