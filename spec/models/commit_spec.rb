# == Schema Information
# Schema version: 20091009155858
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
#  commit_sha     :string(255)
#  user           :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Commit do
  before(:each) do
    @valid_attributes = {
      :message => "value for message",
      :author => "sam i am",
      :committed_date => DateTime.now
    }
  end

  it "should create a new commit for a github repo" do
    commit = Commit.new(@valid_attributes)
    repo = create_github_repo
    repo.commits << commit
    repo.save
    repo.should be_valid
    repo.commits.size.should == 1
  end
end
