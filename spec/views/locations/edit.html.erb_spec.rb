require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/locations/edit.html.erb" do
  include LocationsHelper
  
  before(:each) do
    assigns[:location] = @location = stub_model(Location,
      :new_record? => false,
      :name => ,
      :city => ,
      :state => ,
      :zip => ,
      :lat => ,
      :long => "value for long"
    )
  end

  it "should render edit form" do
    render "/locations/edit.html.erb"
    
    response.should have_tag("form[action=#{location_path(@location)}][method=post]") do
      with_tag('input#location_name[name=?]', "location[name]")
      with_tag('input#location_city[name=?]', "location[city]")
      with_tag('input#location_state[name=?]', "location[state]")
      with_tag('input#location_zip[name=?]', "location[zip]")
      with_tag('input#location_lat[name=?]', "location[lat]")
      with_tag('input#location_long[name=?]', "location[long]")
    end
  end
end


