class AddUdidToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :UDID, :string
  end

  def self.down
    remove_column :coders, :UDID
  end
end
