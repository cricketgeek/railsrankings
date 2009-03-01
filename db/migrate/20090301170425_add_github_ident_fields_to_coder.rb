class AddGithubIdentFieldsToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :github_email, :string
    add_column :coders, :github_location, :string
    add_column :coders, :github_full_name, :string
  end

  def self.down
    remove_column :coders, :github_full_name
    remove_column :coders, :github_location
    remove_column :coders, :github_email
  end
end
