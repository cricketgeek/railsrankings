# == Schema Information
# Schema version: 20090301191852
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
#  forked      :boolean(1)
#  forks       :integer(4)
#

class GithubRepo < ActiveRecord::Base
  belongs_to :coder
  has_many :commits
  
  validates_presence_of :name
  validates_presence_of :url
  
  named_scope :alphabetical, :order => :name
  named_scope :popular, lambda { |*args| { :limit => args.first || 10, :order => "watchers DESC"} }
  named_scope :all_popular, :order => "watchers DESC"
  
  def self.valid_repo_name_and_description?(repo)
    !repo.name.include?("django") || !repo.description.include?("django")
  end
  
  def total_point_value
    watchers * GITHUB_WATCHER_POINTS
  end
  
  generator_for :watchers, :start => 1 do |watcher|
    watcher.succ
  end
  
  generator_for :name, :start => "test_repo" do |name|
    name.succ
  end

  generator_for :url, :start => "http://github.com/test" do |url|
    url.succ
  end
    
end
