class CreateGithubRepos < ActiveRecord::Migration
  def self.up
    create_table :github_repos do |t|
      t.string  :name
      t.string  :url
      t.integer :watchers
      t.string  :description
      t.integer :coder_id
      t.timestamps
    end
  end

  def self.down
    drop_table :github_repos
  end
end
