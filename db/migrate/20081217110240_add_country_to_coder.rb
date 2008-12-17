class AddCountryToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :country, :string
  end

  def self.down
    remove_column :coders, :country
  end
end
