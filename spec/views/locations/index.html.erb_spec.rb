require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/index.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:locations] = [
      stub_model(Location,
        :name => ,
        :city => ,
        :state => ,
        :zip => ,
        :lat => ,
        :long => "value for long"
      ),
      stub_model(Location,
        :name => ,
        :city => ,
        :state => ,
        :zip => ,
        :lat => ,
        :long => "value for long"
      )
    ]
  end

  it "should render list of locations" do
    render "/locations/index.html.erb"
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", , 2)
    response.should have_tag("tr>td", "value for long", 2)
  end
end

