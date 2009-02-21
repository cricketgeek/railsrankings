class AddForkingInfoToGithubRepo < ActiveRecord::Migration
  def self.up
    add_column :github_repos, :forked, :boolean
    add_column :github_repos, :forks, :integer
  end

  def self.down
    remove_column :github_repos, :forks
    remove_column :github_repos, :forked
  end
end
