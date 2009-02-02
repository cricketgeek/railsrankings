class AddCommitedDateToCommit < ActiveRecord::Migration
  def self.up
    add_column :commits, :committed_date, :datetime
  end

  def self.down
    remove_column :commits, :committed_date
  end
end
