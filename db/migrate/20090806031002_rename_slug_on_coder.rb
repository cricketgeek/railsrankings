class RenameSlugOnCoder < ActiveRecord::Migration
  def self.up
    rename_column :coders, :slug, :username
  end

  def self.down
    rename_column :coders, :username, :slug
  end
end
