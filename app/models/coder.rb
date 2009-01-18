require 'ruby-github'

class Coder < ActiveRecord::Base
  #belongs_to :location
  
  define_index do
    indexes [first_name,last_name], :as => :name
    indexes city, company_name, country, nickname
    
    has rank
    has full_rank
  end
  
  validates_uniqueness_of :profile_url
  validates_presence_of :profile_url
  
  named_scope :cities, lambda { |*args| { :select => "city, sum(full_rank) as total,count(*) as count", 
      :conditions => "city is not null AND city <> ''", :limit => args.first || 20, :group => "city", :order => "total DESC" } }
  named_scope :all_cities, :select => "city, sum(full_rank) as total,count(*) as count", 
          :conditions => "city is not null AND city <> ''", :group => "city", :order => "total DESC"
  named_scope :companies, lambda { |*args| { :select => "company_name, sum(full_rank) as total, count(*) as count", 
    :conditions => "company_name is not null AND company_name <> ''", :limit => args.first || 20, :group => "company_name", :order => "total DESC"} }
  named_scope :all_companies, :select => "company_name, sum(full_rank) as total, count(*) as count", 
      :conditions => "company_name is not null AND company_name <> ''", :group => "company_name having total > 0", :order => "total DESC"
  named_scope :top_coders, lambda { |*args| { :limit => args.first || 20, :order => "full_rank DESC" } }
  named_scope :ranked, :conditions => "rank is not null and full_rank > 0", :order => "full_rank DESC"
  
  before_create :default_rank
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def github_repos
    repos = []
    if valid_for_github?
      nicknames = nickname.split(",")
      nicknames.each do |nickname|
        begin
          puts "processing github repo for nickname #{nickname}"
          nickname.strip!
          github_user = GitHub::API.user(nickname)
          repos = repos + github_user.repositories
        rescue Exception => ex
          puts "error geting github repo, #{ex}"
        end
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


