require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coder do
  before(:each) do
    @valid_attributes = {
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :email => "value for email",
      :location => "value for location",
      :rank => "1",
      :website => "value for website",
      :delta => "1",
      :recommendation_count => "1",
      :image_path => "value for image_path"
    }
  end

  it "should create a new instance given valid attributes" do
    Coder.create!(@valid_attributes)
  end
end
