require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/new.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:location] = stub_model(Location,
      :new_record? => true,
      :name => ,
      :city => ,
      :state => ,
      :zip => ,
      :lat => ,
      :long => "value for long"
    )
  end

  it "should render new form" do
    render "/locations/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", locations_path) do
      with_tag("input#location_name[name=?]", "location[name]")
      with_tag("input#location_city[name=?]", "location[city]")
      with_tag("input#location_state[name=?]", "location[state]")
      with_tag("input#location_zip[name=?]", "location[zip]")
      with_tag("input#location_lat[name=?]", "location[lat]")
      with_tag("input#location_long[name=?]", "location[long]")
    end
  end
end


