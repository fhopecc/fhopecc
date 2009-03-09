class CreateMlogs < ActiveRecord::Migration
  def self.up
    create_table :mlogs do |t|
			t.integer    :user_id
			t.date       :date
			t.float      :value, :default => 0.0
			t.text       :comment
      t.timestamps
    end
  end

  def self.down
    drop_table :mlogs
  end
end

