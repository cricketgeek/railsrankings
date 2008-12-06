require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CodersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "coders", :action => "index").should == "/coders"
    end
  
    it "should map #new" do
      route_for(:controller => "coders", :action => "new").should == "/coders/new"
    end
  
    it "should map #show" do
      route_for(:controller => "coders", :action => "show", :id => 1).should == "/coders/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "coders", :action => "edit", :id => 1).should == "/coders/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "coders", :action => "update", :id => 1).should == "/coders/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "coders", :action => "destroy", :id => 1).should == "/coders/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/coders").should == {:controller => "coders", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/coders/new").should == {:controller => "coders", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/coders").should == {:controller => "coders", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/coders/1").should == {:controller => "coders", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/coders/1/edit").should == {:controller => "coders", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/coders/1").should == {:controller => "coders", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/coders/1").should == {:controller => "coders", :action => "destroy", :id => "1"}
    end
  end
end
