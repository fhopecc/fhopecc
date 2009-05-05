class RemoveGlobalize < ActiveRecord::Migration
	def drop_exist_table table
    drop_table(table) if table_exists?(table)
	end

  def self.up
    drop_exist_table :globalize_countries
    drop_exist_table :globalize_languages
    drop_exist_table :globalize_translations
  end

  def self.down
  end
end
