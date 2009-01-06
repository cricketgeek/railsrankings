class AddCoreContribToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :core_contributor, :boolean, :default => false
  end

  def self.down
    remove_column :coders, :core_contributor
  end
end
