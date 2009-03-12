class AddTwitterAccountToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :twitter_name, :string
  end

  def self.down
    remove_column :coders, :twitter_name
  end
end
