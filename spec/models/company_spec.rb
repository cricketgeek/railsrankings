# == Schema Information
# Schema version: 20090301191852
#
# Table name: companies
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  location     :string(255)
#  logo_path    :string(255)
#  coders_count :integer(4)
#  full_rank    :integer(4)
#  railsrank    :integer(4)
#  wwr_profile  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Company do

  
  it "should create a new instance given valid attributes" do
    company = create_company
    company.save!
  end


end
