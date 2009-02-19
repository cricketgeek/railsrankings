# == Schema Information
# Schema version: 20090215220047
#
# Table name: github_repos
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  url         :string(255)
#  watchers    :integer(4)
#  description :string(255)
#  coder_id    :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe GithubRepo do
  before(:each) do
    @coder_big = create_coder({:first_name => "Rein",:last_name => "Heinrichs", :profile_url => "http://wwr.com/reinh",:full_rank => 250000})
    @valid_attributes = {
      :name => "super codes",
      :url => "http://github.com/something"
    }
  end

  it "should create a new github repo instance" do
    repo = GithubRepo.new(@valid_attributes)
    repo.coder = @coder_big
    repo.save!
  end
end