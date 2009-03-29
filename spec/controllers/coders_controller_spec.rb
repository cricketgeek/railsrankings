require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CodersController do

  before do
    @all_companies = mock("all companies scope", :[] => [])
  end

  describe "all companies" do
    it "should set the first page of companies and render template"
  end
  
  describe "all cities" do
    it "should set the first page of cities and render template"    
  end
  
  describe "all coders" do
    it "should set the first page of coders and render template"    
  end
  
  describe  "search" do
    it "should search on atlanta and find coders sorted by railsrank"
  end
  
  describe  "show" do
    it "should show profile of user and render html"
  end
  
  describe "get_coders" do
    it "should return coders as json based on comma delimited slug names"
    
    it "should return coders as json base on comma delimited nicknames or aliases"
  end
  

end
