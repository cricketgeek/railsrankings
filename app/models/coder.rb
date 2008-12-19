require 'ruby-github'

class Coder < ActiveRecord::Base
  #belongs_to :location
  
  define_index do
    indexes [first_name,last_name], :as => :name
    indexes city, company_name, country, nickname
    
    has rank
  end
  
  validates_uniqueness_of :profile_url
  validates_presence_of :profile_url
  
  named_scope :ranked, :conditions => "rank is not null"
  
  before_create :default_rank
  
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def github_repos
    repos = []
    if valid_for_github?
      nicknames = nickname.split(",")
      begin
        nicknames.each do |nickname|
          nickname.strip!
          github_user = GitHub::API.user(nickname)
          repos = repos + github_user.repositories
        end
      rescue Exception => ex
        puts "error geting github repo, #{ex}"
      end
    end
    repos
  end
  
  private

  def valid_for_github?
    nickname and (not nickname.blank?) and nickname.upcase != "NONE"
  end
  
  def default_rank
    rank = 9999 if rank.blank?
  end
  
end


