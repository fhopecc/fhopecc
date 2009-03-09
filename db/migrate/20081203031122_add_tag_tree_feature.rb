class AddTagTreeFeature < ActiveRecord::Migration
  def self.up
		create_table "tag_trees" do |t|
			t.integer :user_id
			t.text    :tag_tree
		end
  end

  def self.down
		drop_table  "tag_trees"
  end
end
