require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coders/index.html.erb" do
  include CodersHelper
  
  before(:each) do
    assigns[:coders] = [
      stub_model(Coder,
        :first_name => "value for first_name",
        :last_name => "value for last_name",
        :email => "value for email",
        :location => "value for location",
        :rank => "1",
        :website => "value for website",
        :delta => "1",
        :recommendation_count => "1",
        :image_path => "value for image_path"
      ),
      stub_model(Coder,
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
    ]
  end

  it "should render list of coders" do
    render "/coders/index.html.erb"
    response.should have_tag("tr>td", "value for first_name", 2)
    response.should have_tag("tr>td", "value for last_name", 2)
    response.should have_tag("tr>td", "value for email", 2)
    response.should have_tag("tr>td", "value for location", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for website", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "1", 2)
    response.should have_tag("tr>td", "value for image_path", 2)
  end
end

