class CreateResultsAds < ActiveRecord::Migration
  def self.up
    create_table :results_ads do |t|
      t.string :link
      t.string :description
      t.string :link_text
      t.integer :click_count
      t.integer :view_count

      t.timestamps
    end
  end

  def self.down
    drop_table :results_ads
  end
end
