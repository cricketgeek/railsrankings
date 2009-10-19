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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe BlockAd do
  before(:each) do
    @valid_attributes = {
      :link => "value for link",
      :image_path => "value for image_path",
      :click_count => 1,
      :views => 1
    }
  end

  it "should create a new instance given valid attributes" do
    BlockAd.create!(@valid_attributes)
  end
end
