class AddUdidToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :udid, :string
  end

  def self.down
    remove_column :locations, :udid
  end
end
