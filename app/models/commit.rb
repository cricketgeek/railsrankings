class Commit < ActiveRecord::Base
  belongs_to :github_repo
  
end
