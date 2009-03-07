require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CodersHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should be included in the object returned by #helper" do
    included_modules = (class << helper; self; end).send :included_modules
    included_modules.should include(CodersHelper)
  end

  describe "core contributor and team members" do
    before do
        @coder = Coder.new( :first_name => "Matt", 
                            :last_name => "Aimonetti", 
                            :nickname => "mattetti", 
                            :profile_url => "http://www.workingwithrails.com/person/6065-matt-aimonetti",
                            :core_team_member => true
                          )
    end
    
    it "should return Rails Core Team Member" do
      helper.rails_core_status(@coder).should == "Rails Core Team Member"
    end
  end
end
