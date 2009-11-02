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
