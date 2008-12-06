class AddProfileUrlToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :profile_url, :string
  end

  def self.down
    remove_column :coders, :profile_url
  end
end
