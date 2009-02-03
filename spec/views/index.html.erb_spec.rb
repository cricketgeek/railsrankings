require File.dirname(__FILE__) + "/../spec_helper"

describe 'coders/index' do

  it "should render a text box and search button" do
    coder = Coder.generate
    coder.slug = "mark-jones"
    coder.rank = 0
    coder.image_path = ""
    coders = [coder]
    coders.stub!(:total_pages => 1)
    assigns[:coders] = coders
    assigns[:count] = 1
    render "coders/index"
    response.should have_text_field_for(:search)
  end

end