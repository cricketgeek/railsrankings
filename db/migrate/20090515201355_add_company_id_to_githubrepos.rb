class AddCompanyIdToGithubrepos < ActiveRecord::Migration
  def self.up
    add_column :github_repos, :company_id, :integer
  end

  def self.down
    remove_column :github_repos, :company_id
  end
end
