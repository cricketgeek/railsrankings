# == Schema Information
# Schema version: 20091009155858
#
# Table name: results_ads
#
#  id          :integer(4)      not null, primary key
#  link        :string(255)
#  description :string(255)
#  link_text   :string(255)
#  click_count :integer(4)
#  view_count  :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class ResultsAd < ActiveRecord::Base
end
