class AddUpdatedBoolToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :updated, :boolean
  end

  def self.down
    remove_column :coders, :updated
  end
end
