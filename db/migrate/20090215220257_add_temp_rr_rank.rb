class AddTempRrRank < ActiveRecord::Migration
  def self.up
    add_column :coders, :railsrank, :integer, :default => MAX_RANK
  end

  def self.down
    remove_column :coders, :railsrank
  end
end
