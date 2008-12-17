class AddNicknameToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :nickname, :string
  end

  def self.down
    remove_column :coders, :nickname
  end
end
