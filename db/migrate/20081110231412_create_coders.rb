class CreateCoders < ActiveRecord::Migration
  def self.up
    create_table :coders do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :location
      t.integer :rank
      t.string :website
      t.integer :delta
      t.integer :recommendation_count
      t.string :image_path

      t.timestamps
    end
  end

  def self.down
    drop_table :coders
  end
end
