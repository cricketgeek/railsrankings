class RenameLongToLonOnLocation < ActiveRecord::Migration
  def self.up
    rename_column :locations, :long, :lon
  end

  def self.down
    rename_column :locations, :lon, :long
  end
end
