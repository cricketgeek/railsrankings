class RemoveCommitsWithNoSha < ActiveRecord::Migration
  def self.up
    Commit.delete_all
  end

  def self.down
  end
end
