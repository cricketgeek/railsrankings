class AddIndexes < ActiveRecord::Migration
  def self.up
    add_index :coders, :profile_url
    add_index :coders, :full_rank
    add_index :coders, :rank
  end

  def self.down
    remove_index :coders, :profile_url
    remove_index :coders, :full_rank
    remove_index :coders, :rank
  end
end
