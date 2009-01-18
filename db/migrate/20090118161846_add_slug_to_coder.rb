class AddSlugToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :slug, :string
  end

  def self.down
    remove_column :coders, :slug
  end
end
