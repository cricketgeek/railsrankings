class AddCoreTeamMemberFieldToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :core_team_member, :boolean
  end

  def self.down
    remove_column :coders, :core_team_member
  end
end
