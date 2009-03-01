class AddGeoFieldsToCoders < ActiveRecord::Migration
  def self.up
    add_column :coders, :latitude, :float
    add_column :coders, :longitude, :float
  end

  def self.down
    remove_column :coders, :longitude
    remove_column :coders, :latitude
  end
end
