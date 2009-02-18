# == Schema Information
# Schema version: 20090215220047
#
# Table name: commits
#
#  id             :integer(4)      not null, primary key
#  message        :string(255)
#  author         :string(255)
#  github_repo_id :integer(4)
#  created_at     :datetime
#  updated_at     :datetime
#  committed_date :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Commit do
  before(:each) do
    @valid_attributes = {
      :message => "value for message"
    }
  end

  it "should create a new instance given valid attributes" do
    Commit.create!(@valid_attributes)
  end
end
