class AddGithubWatchersToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :github_watchers, :integer, :default => 0
  end

  def self.down
    remove_column :coders, :github_watchers
  end
end
