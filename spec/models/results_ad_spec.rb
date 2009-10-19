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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ResultsAd do
  before(:each) do
    @valid_attributes = {
      :link => "value for link",
      :description => "value for description",
      :link_text => "value for link_text",
      :click_count => 1,
      :view_count => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ResultsAd.create!(@valid_attributes)
  end
end
