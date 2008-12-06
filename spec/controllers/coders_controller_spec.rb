require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CodersController do

  def mock_coder(stubs={})
    @mock_coder ||= mock_model(Coder, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all coders as @coders" do
      Coder.should_receive(:find).with(:all).and_return([mock_coder])
      get :index
      assigns[:coders].should == [mock_coder]
    end

    describe "with mime type of xml" do
  
      it "should render all coders as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Coder.should_receive(:find).with(:all).and_return(coders = mock("Array of Coders"))
        coders.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested coder as @coder" do
      Coder.should_receive(:find).with("37").and_return(mock_coder)
      get :show, :id => "37"
      assigns[:coder].should equal(mock_coder)
    end
    
    describe "with mime type of xml" do

      it "should render the requested coder as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        Coder.should_receive(:find).with("37").and_return(mock_coder)
        mock_coder.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new coder as @coder" do
      Coder.should_receive(:new).and_return(mock_coder)
      get :new
      assigns[:coder].should equal(mock_coder)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested coder as @coder" do
      Coder.should_receive(:find).with("37").and_return(mock_coder)
      get :edit, :id => "37"
      assigns[:coder].should equal(mock_coder)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created coder as @coder" do
        Coder.should_receive(:new).with({'these' => 'params'}).and_return(mock_coder(:save => true))
        post :create, :coder => {:these => 'params'}
        assigns(:coder).should equal(mock_coder)
      end

      it "should redirect to the created coder" do
        Coder.stub!(:new).and_return(mock_coder(:save => true))
        post :create, :coder => {}
        response.should redirect_to(coder_url(mock_coder))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved coder as @coder" do
        Coder.stub!(:new).with({'these' => 'params'}).and_return(mock_coder(:save => false))
        post :create, :coder => {:these => 'params'}
        assigns(:coder).should equal(mock_coder)
      end

      it "should re-render the 'new' template" do
        Coder.stub!(:new).and_return(mock_coder(:save => false))
        post :create, :coder => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested coder" do
        Coder.should_receive(:find).with("37").and_return(mock_coder)
        mock_coder.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :coder => {:these => 'params'}
      end

      it "should expose the requested coder as @coder" do
        Coder.stub!(:find).and_return(mock_coder(:update_attributes => true))
        put :update, :id => "1"
        assigns(:coder).should equal(mock_coder)
      end

      it "should redirect to the coder" do
        Coder.stub!(:find).and_return(mock_coder(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(coder_url(mock_coder))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested coder" do
        Coder.should_receive(:find).with("37").and_return(mock_coder)
        mock_coder.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :coder => {:these => 'params'}
      end

      it "should expose the coder as @coder" do
        Coder.stub!(:find).and_return(mock_coder(:update_attributes => false))
        put :update, :id => "1"
        assigns(:coder).should equal(mock_coder)
      end

      it "should re-render the 'edit' template" do
        Coder.stub!(:find).and_return(mock_coder(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested coder" do
      Coder.should_receive(:find).with("37").and_return(mock_coder)
      mock_coder.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the coders list" do
      Coder.stub!(:find).and_return(mock_coder(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(coders_url)
    end

  end

end
