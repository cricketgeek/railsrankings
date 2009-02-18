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

class GithubRepo < ActiveRecord::Base
  belongs_to :coder
  has_many :commits
  
end
