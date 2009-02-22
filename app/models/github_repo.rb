# == Schema Information
# Schema version: 20090221173936
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
  named_scope :popular, :order => "watchers DESC"
  
end
