class AddCommitSha < ActiveRecord::Migration
  def self.up
    add_column :commits, :commit_sha, :string
    add_column :commits, :user, :string
  end

  def self.down
    remove_column :commits, :user
    remove_column :commits, :commit_sha
  end
end
