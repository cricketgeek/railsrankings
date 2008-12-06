class ChangeLocationColNameOnCoder < ActiveRecord::Migration
  def self.up
    rename_column :coders, :location, :city
  end

  def self.down
    rename_column :coders, :city, :location
  end
end
