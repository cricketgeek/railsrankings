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
