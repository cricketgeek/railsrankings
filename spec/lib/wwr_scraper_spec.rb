require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WWRScraper do
  
  describe "parsing a profile url" do
    
    before do
      @scraper = WWRScraper.new
    end
    
    it "should create a coder based on the wwr profile data" do
      @scraper.should_receive(:rerun_rankings)
      @scraper.reprocess_for_one_person("http://www.workingwithrails.com/person/12633-mark-jones")      
      
      coders = Coder.find(:all,:conditions => "first_name = 'Mark' and last_name='Jones'")
      coders.size.should == 1
      coder = coders.first
      coder.whole_name.should == "Mark Jones"
      coder.github_repos.size.should == 3
      coder.nickname.downcase.should == "cricketgeek"
      
    end    
    
  end
  
  
  
end