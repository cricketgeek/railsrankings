class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :zip
      t.string :lat
      t.string :long
      t.integer :coder_id

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end
