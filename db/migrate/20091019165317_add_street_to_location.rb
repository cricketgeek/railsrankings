class AddStreetToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :street, :string
  end

  def self.down
    remove_column :locations, :street
  end
end
