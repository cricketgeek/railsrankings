class AddCompanyNameToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :company_name, :string
  end

  def self.down
    remove_column :coders, :company_name
  end
end
