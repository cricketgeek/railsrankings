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
  
  describe "paging with index for all pages" do
    
    it "should return 3 based on first page and index of 2" do
      @params = {:page => 1}
      helper.stub!(:params).and_return(@params)     
      helper.determine_rank_for_paging(2).should == 3
    end
    
    it "should return 100 based on page being 2 and index 49" do
      @params = {:page => 2}
      helper.stub!(:params).and_return(@params)
      helper.determine_rank_for_paging(49).should == 100
    end
    
  end
end
