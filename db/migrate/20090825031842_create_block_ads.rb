class CreateBlockAds < ActiveRecord::Migration
  def self.up
    create_table :block_ads do |t|
      t.string :link
      t.string :image_path
      t.integer :click_count
      t.integer :views
      t.string :alt_text

      t.timestamps
    end
  end

  def self.down
    drop_table :block_ads
  end
end
