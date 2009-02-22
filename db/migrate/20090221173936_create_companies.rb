class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies do |t|
      t.string :name
      t.string :location
      t.string :logo_path
      t.integer :coders_count
      t.integer :full_rank
      t.integer :railsrank
      t.string :wwr_profile

      t.timestamps
    end
    
    add_column :coders, :company_id, :integer
  end

  def self.down
    drop_table :companies
    remove_column :coders, :company_id
  end
end
