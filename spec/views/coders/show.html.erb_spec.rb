require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coders/show.html.erb" do
  include CodersHelper
  
  before(:each) do
    assigns[:coder] = @coder = stub_model(Coder,
      :first_name => "value for first_name",
      :last_name => "value for last_name",
      :email => "value for email",
      :location => "value for location",
      :rank => "1",
      :website => "value for website",
      :delta => "1",
      :recommendation_count => "1",
      :image_path => "value for image_path"
    )
  end

  it "should render attributes in <p>" do
    render "/coders/show.html.erb"
    response.should have_text(/value\ for\ first_name/)
    response.should have_text(/value\ for\ last_name/)
    response.should have_text(/value\ for\ email/)
    response.should have_text(/value\ for\ location/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ website/)
    response.should have_text(/1/)
    response.should have_text(/1/)
    response.should have_text(/value\ for\ image_path/)
  end
end

