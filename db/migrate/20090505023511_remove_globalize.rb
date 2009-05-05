class RemoveGlobalize < ActiveRecord::Migration
  def self.up
    drop_table :globalize_countries
    drop_table :globalize_languages
    drop_table :globalize_translations
  end

  def self.down
  end
end
