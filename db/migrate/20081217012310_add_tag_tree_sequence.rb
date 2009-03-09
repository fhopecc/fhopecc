class AddTagTreeSequence < ActiveRecord::Migration
  def self.up
		add_column :tag_trees, :sequence, :integer, :default => 0
  end

  def self.down
		remove_column :tag_trees, :sequence
  end
end
