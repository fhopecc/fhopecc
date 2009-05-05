class RemoveGlobalize < ActiveRecord::Migration
  def self.up
    drop_table :globalize_countries if table_exists? :globalize_countries
    drop_table :globalize_languages if table_exists? :globalize_languages
    drop_table :globalize_translations if table_exists? :globalize_translations
  end

  def self.down
  end
end
