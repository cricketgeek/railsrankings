require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do

  before do
    @top_coders = mock("top coders scope", :[] => [])
  end
  
  it "should assign coder vars and render appropriate partials" do
    Coder.should_receive(:top_ranked).with(10).and_return(@top_coders)
    get :index
    assigns[:top_ten_coders].should == @top_coders
    response.should render_template('index')
  end
  

end
