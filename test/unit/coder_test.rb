require File.dirname(__FILE__) + '/../test_helper'

class CoderTest < Test::Unit::TestCase
  
  context "a coder does" do
    
    setup do
      @coder = Coder.new(:profile_url => "http://workingwithrails.com/coder123",:first_name => "mark",:last_name => "jones")
    end
    
    should "return the coder's full name" do
      assert_equal @coder.full_name, "mark jones"
      
    end
    
  end
  
end