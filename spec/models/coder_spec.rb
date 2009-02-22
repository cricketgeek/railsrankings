# == Schema Information
# Schema version: 20090221173936
#
# Table name: coders
#
#  id                    :integer(4)      not null, primary key
#  first_name            :string(255)
#  last_name             :string(255)
#  email                 :string(255)
#  city                  :string(255)
#  rank                  :integer(4)
#  website               :string(255)
#  delta                 :integer(4)
#  recommendation_count  :integer(4)
#  image_path            :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  profile_url           :string(255)
#  location_id           :integer(4)
#  company_name          :string(255)
#  country               :string(255)
#  nickname              :string(255)
#  github_watchers       :integer(4)      default(0)
#  github_url            :string(255)
#  full_rank             :integer(4)      default(0)
#  core_contributor      :boolean(1)
#  slug                  :string(255)
#  is_available_for_hire :boolean(1)
#  railsrank             :integer(4)      default(9999)
#  company_id            :integer(4)
#


require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Coder do

  
  it "should create a new instance given valid attributes" do
    coder = create_coder
    coder.save!
  end
  
  describe  "Sorting coders" do
  
    before :each do
      @coder_big = create_coder({:first_name => "Rein",:last_name => "Heinrichs", :profile_url => "http://wwr.com/reinh",:full_rank => 250000})
      @coder_small = create_coder({:first_name => "Mark",:last_name => "Jones", :profile_url => "http://wwr.com/markj",:full_rank => 2500})
      @coders = [@coder_small,@coder_big]
    end
  
    it "should sort coders by full_rank" do
      @coders.sort!
      @coders.first.should == @coder_big
    end
  
    it "should sort by github repo info after full_rank is equal" do
      @coder_big.full_rank = @coder_small.full_rank
      @coder_small.github_repos << create_github_repo({:name => "big time project",:watchers => 250})
      @coders.sort!
      @coders.first.should == @coder_small
    end

  end  

  
end
