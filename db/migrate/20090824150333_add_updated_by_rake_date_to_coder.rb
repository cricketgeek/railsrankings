class AddUpdatedByRakeDateToCoder < ActiveRecord::Migration
  def self.up
    add_column :coders, :scraperUpdateDate, :datetime, :default => DateTime.now
  end

  def self.down
    remove_column :coders, :scraperUpdateDate
  end
end
