# == Schema Information
# Schema version: 20090301191852
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
#  core_team_member      :boolean(1)
#  github_email          :string(255)
#  github_location       :string(255)
#  github_full_name      :string(255)
#  latitude              :float
#  longitude             :float
#  whole_name            :string(255)
#

require 'ruby-github'

class Coder < ActiveRecord::Base
  include Comparable
  
  belongs_to :company
  
  has_friendly_id :username, :use_slug => true, :strip_diacritics => true
  has_many :github_repos
  
  define_index do
    indexes [first_name,last_name], :as => :name
    indexes whole_name, city, company_name, country, nickname
    #indexes github_repos.name, :as => :repo_names
    
    has rank
    has full_rank
    has railsrank
  end
  
  validates_uniqueness_of :profile_url
  validates_presence_of :profile_url
  
  generator_for :profile_url, :start => 'www.wwr.com/test' do |prev|
      base, user = prev.split('/')
      "#{base}/#{user.succ}"
  end
  
  generator_for :slug, :start => "first-last" do |prev|
    first, last = prev.split('-')
    "#{first.succ}-#{last.succ}"
  end
  
  
  def <=>(other)
    if other.full_rank > self.full_rank
      return 1
    elsif other.full_rank < self.full_rank
      return -1
    else
      return other.github_repos.size <=> self.github_repos.size
    end
  end
  
  named_scope :cities, lambda { |*args| { :select => "city as name, railsrank, sum(full_rank) as total,count(*) as count", 
      :conditions => "city is not null AND city <> ''", :limit => args.first || 15, :group => "city", :order => "total DESC" } }
  named_scope :all_cities, :select => "city as name, sum(full_rank) as total,count(*) as count", 
          :conditions => "city is not null AND city <> ''", :group => "city", :order => "total DESC"
  named_scope :companies, lambda { |*args| { :select => "company_name as name, railsrank, sum(full_rank) as total, count(*) as count", 
    :conditions => "company_name is not null AND company_name <> ''", :limit => args.first || 15, :group => "company_name", :order => "total DESC"} }
  named_scope :all_companies, :select => "company_name as name, railsrank, sum(full_rank) as total, count(*) as count", 
      :conditions => "company_name is not null AND company_name <> ''", :group => "company_name having total > 0", :order => "total DESC"
  named_scope :top_coders, lambda { |*args| { :limit => args.first || 15, :order => "full_rank DESC" } }
  named_scope :ranked, :conditions => "rank is not null and full_rank > 0", :order => "full_rank DESC"
  named_scope :top_ranked, lambda { |*args| { :limit => args.first || 10, :order => "railsrank ASC" } }
  
  before_create :default_rank
  

  
  def full_name
    return "#{whole_name}" if whole_name
    return "#{first_name} #{last_name}"
  end
  
  def recent_commits
    commits = []
    if github_repos.size > 0
      limit = github_repos.size > 30 ? (github_repos.size / 2) + 5 : github_repos.size
      commits = Commit.find_by_sql(["select * from commits where github_repo_id in (?) order by committed_date DESC limit ?",github_repo_ids,15])      
    end
    return commits
  end
  
  def clean_nicknames
    if valid_for_github?
      parse_string = nickname.gsub(","," ").gsub(";"," ").gsub("."," ")
      nicknames = parse_string.split
      nicknames.reject! { |name| ["on","at","@","the","github","code","rails"].include?(name)}
      nicknames.map{|nick| cleanse_bad_aliases(nick)}
    else
      []
    end
  end
  
  def has_alias?(alias_name)
    known_nicknames = clean_nicknames
    known_nicknames.include?(alias_name)
  end
  
  def cleanse_bad_aliases(alias_name)
    clean_name = alias_name
    
    if alias_name.downcase == "rails"
      return "not_rails"
    end
    
    if alias_name and self.last_name
      if self.first_name and self.first_name == 'Maciafts'
        clean_name = "not_sam"
      elsif alias_name.downcase == "rails"
        clean_name = "not_rails"
      elsif alias_name.downcase == "pieter" and self.last_name.downcase == "botha"
        clean_name = "not_pieter"
      elsif alias_name.downcase == "tobias" and self.last_name.downcase != "Crawley"
        clean_name = "not_tobias"
      elsif alias_name.downcase == "sam" and (self.first_name.downcase != "sam" or self.last_name.downcase != "smoot")
        clean_name = "not_sam"
      elsif alias_name.downcase == "chris" and self.last_name != "Bailey"
        clean_name = "not_chris"
      elsif alias_name.downcase == "josh" and self.last_name != "Peek"
        clean_name = "not_josh"
      elsif alias_name.downcase == "tobi" and self.last_name == "Schlottke"
        clean_name = "not_tobi"
      elsif alias_name.downcase == "andre" and (self.first_name != "Andre" || self.last_name != "Lewis")
        clean_name = "not_andre_lewis"
      elsif alias_name.downcase == "clemens" and (self.first_name != "Clemens" || self.last_name != "Kofler")
        clean_name = "not_clemens_kofler"
      elsif alias_name.downcase == "gabriel" and (self.first_name != "Gabriel" || self.last_name != "Handford")
        clean_name = "not_gabriel_handford"
      elsif alias_name.downcase == "code"
        clean_name = "code_is_an_invalid_alias"
      elsif alias_name.downcase == "robin" and (self.first_name != "Robin" || self.last_name != "Lu")
        clean_name = "not_robin_lu"
      elsif alias_name.downcase == "dan" and (self.whole_name.downcase != "dan benjamin")
        clean_name = "not_dan_benjamin"
      elsif alias_name.downcase == "sr" and (self.whole_name.downcase != "simon rozet")
        clean_name = "not_simon_rozet"
      elsif alias_name.downcase == "twp" and (self.whole_name.downcase != "tim pease")
        clean_name = "not_tim_pease"
      elsif alias_name.downcase == "rich" and (self.whole_name.downcase != "rich cavanaugh")
        clean_name = "not_rich_cavanaugh"
      end
    end
    return clean_name
  end
  
  def recalculate_full_rank
    rank = self.rank.blank? ? MAX_RANK : self.rank.to_i
    bonus = rank < 100 ? TOP_100_WWR_BONUS : 0
    core_contrib_bonus = self.core_contributor ? CORE_CONTRIBUTOR_BONUS : 0
    core_team_member_bonus = self.core_team_member ? CORE_TEAM_BONUS : 0
    total_rank = (MAX_RANK - rank) + (self.github_watchers * GITHUB_WATCHER_POINTS) + bonus + core_contrib_bonus + core_team_member_bonus
  end
  
  def retrieve_github_repos
    repos = []
    nicks_to_use = clean_nicknames
    got_github_ident_info = false
    nicks_to_use.each do |nickname|
      begin
        nickname = cleanse_bad_aliases(nickname)
        github_user = GitHub::API.user(nickname)
        unless got_github_ident_info
          get_github_ident_info(github_user) 
          got_github_ident_info = true
        end
        github_user.repositories.each do |repo|
          repo.nickname_used = nickname
        end
        repos = repos + github_user.repositories
      rescue Exception => ex
        puts "error geting github repo, #{ex}"
      end
    end
    repos ||= []
  end
  
  def full_rank_formatted
    "#{helpers.number_with_delimiter(self.full_rank, {:delimeter => ","})}"
  end
  
  def helpers
    ActionController::Base.helpers
  end
  
  private
  
  def get_github_ident_info(github_user)
    self.github_email = github_user.email
    self.github_full_name = github_user.name
    self.github_location = github_user.location
    self.save
  end

  def valid_for_github?
    nickname and (not nickname.blank?) and nickname.upcase != "NONE"
  end
  
  def default_rank
    rank = MAX_RANK if rank.blank?
  end
  
end


