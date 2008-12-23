class AddGithubUrlToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :github_url, :string
  end

  def self.down
    remove_column :coders, :github_url
  end
end
