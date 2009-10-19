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

class Commit < ActiveRecord::Base
  belongs_to :github_repo
  
  validates_uniqueness_of :commit_sha
  validates_presence_of :message
  validates_presence_of :author
  validates_presence_of :committed_date
  
  named_scope :latest, lambda { |*args| { :limit => args.first || 5, :order => "committed_date DESC" }}
  
end
