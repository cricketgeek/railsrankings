
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coder do
  before(:each) do
    @valid_attributes = {
      :first_name => "Mark",
      :last_name => "Jones",
      :profile_url => "http://www.wwr.com/mark-jones"
    }
  end

  it "should create a new instance given valid attributes" do
    Coder.create!(@valid_attributes)
  end
  
  
  
end