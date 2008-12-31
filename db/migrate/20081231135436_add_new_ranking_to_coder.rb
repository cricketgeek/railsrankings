class AddNewRankingToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :full_rank, :integer, :default => 0
  end

  def self.down
    remove_column :coders, :full_rank
  end
end
