require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Location do
  before(:each) do
    @valid_attributes = {
      :name => ,
      :city => ,
      :state => ,
      :zip => ,
      :lat => ,
      :long => "value for long"
    }
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end
end
