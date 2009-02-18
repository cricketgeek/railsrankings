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

class Commit < ActiveRecord::Base
  belongs_to :github_repo
  
  named_scope :latest, lambda { |*args| { :limit => args.first || 5, :order => "committed_date" }}
  
end
