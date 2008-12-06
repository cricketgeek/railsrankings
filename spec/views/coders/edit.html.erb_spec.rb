require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/coders/edit.html.erb" do
  include CodersHelper
  
  before(:each) do
    assigns[:coder] = @coder = stub_model(Coder,
      :new_record? => false,
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

  it "should render edit form" do
    render "/coders/edit.html.erb"
    
    response.should have_tag("form[action=#{coder_path(@coder)}][method=post]") do
      with_tag('input#coder_first_name[name=?]', "coder[first_name]")
      with_tag('input#coder_last_name[name=?]', "coder[last_name]")
      with_tag('input#coder_email[name=?]', "coder[email]")
      with_tag('input#coder_location[name=?]', "coder[location]")
      with_tag('input#coder_rank[name=?]', "coder[rank]")
      with_tag('input#coder_website[name=?]', "coder[website]")
      with_tag('input#coder_delta[name=?]', "coder[delta]")
      with_tag('input#coder_recommendation_count[name=?]', "coder[recommendation_count]")
      with_tag('input#coder_image_path[name=?]', "coder[image_path]")
    end
  end
end


