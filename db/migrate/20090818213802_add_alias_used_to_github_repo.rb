class AddAliasUsedToGithubRepo < ActiveRecord::Migration
  def self.up
    add_column :github_repos, :alias_used, :string
  end

  def self.down
    remove_column :github_repos, :alias_used
  end
end
