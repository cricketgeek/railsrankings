class AddIsAvailableToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :is_available_for_hire, :boolean
  end

  def self.down
    remove_column :coders, :is_available_for_hire
  end
end
