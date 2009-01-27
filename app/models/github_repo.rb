class GithubRepo < ActiveRecord::Base
  belongs_to :coder
  has_many :commits
  
end
