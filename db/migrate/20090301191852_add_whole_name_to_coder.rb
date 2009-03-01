class AddWholeNameToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :whole_name, :string
  end

  def self.down
    remove_column :coders, :whole_name
  end
end
