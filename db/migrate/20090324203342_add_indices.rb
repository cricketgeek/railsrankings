class AddIndices < ActiveRecord::Migration
  def self.up
    add_index :commits, :commit_sha
    add_index :github_repos, :coder_id
    add_index :commits, :github_repo_id
  end

  def self.down
    remove_index :commits, :github_repo_id
    remove_index :github_repos, :coder_id
    remove_index :commits, :commit_sha
    
  end
end
