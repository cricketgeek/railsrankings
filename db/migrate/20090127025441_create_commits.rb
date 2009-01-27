class CreateCommits < ActiveRecord::Migration
  def self.up
    create_table :commits do |t|
      t.string  :message
      t.string  :author
      t.integer :github_repo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :commits
  end
end
