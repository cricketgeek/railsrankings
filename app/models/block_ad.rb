# == Schema Information
# Schema version: 20091009155858
#
# Table name: block_ads
#
#  id          :integer(4)      not null, primary key
#  link        :string(255)
#  image_path  :string(255)
#  click_count :integer(4)
#  views       :integer(4)
#  alt_text    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class BlockAd < ActiveRecord::Base
end
