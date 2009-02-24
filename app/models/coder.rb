# == Schema Information
# Schema version: 20090221173936
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
#

require 'ruby-github'

class Coder < ActiveRecord::Base
  include Comparable
  
  belongs_to :company
  
  has_friendly_id :slug, :strip_diacritics => true, :reserved => ["new", "index"]
  has_many :github_repos
  
  define_index do
    indexes [first_name,last_name], :as => :name
    indexes city, company_name, country, nickname
    
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
  
  named_scope :cities, lambda { |*args| { :select => "city, railsrank, sum(full_rank) as total,count(*) as count", 
      :conditions => "city is not null AND city <> ''", :limit => args.first || 20, :group => "city", :order => "total DESC" } }
  named_scope :all_cities, :select => "city, sum(full_rank) as total,count(*) as count", 
          :conditions => "city is not null AND city <> ''", :group => "city", :order => "total DESC"
  named_scope :companies, lambda { |*args| { :select => "company_name, railsrank, sum(full_rank) as total, count(*) as count", 
    :conditions => "company_name is not null AND company_name <> ''", :limit => args.first || 20, :group => "company_name", :order => "total DESC"} }
  named_scope :all_companies, :select => "company_name, railsrank, sum(full_rank) as total, count(*) as count", 
      :conditions => "company_name is not null AND company_name <> ''", :group => "company_name having total > 0", :order => "total DESC"
  named_scope :top_coders, lambda { |*args| { :limit => args.first || 20, :order => "full_rank DESC" } }
  named_scope :ranked, :conditions => "rank is not null and full_rank > 0", :order => "full_rank DESC"
  
  before_create :default_rank
  

  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  def recent_commits
    github_repos.size > 0 ? Commit.find_by_sql(["select * from commits where github_repo_id in (?) order by committed_date DESC limit 8",github_repo_ids]) : []
  end
  
  def clean_nicknames
    if valid_for_github?
      parse_string = nickname.gsub(","," ").gsub(";"," ").gsub("."," ")
      nicknames = parse_string.split
      nicknames.reject! { |name| ["on","at","@","the","github"].include?(name)} 
      nicknames 
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
      elsif alias_name.downcase == "tobias" and self.last_name.downcase == "Kahre"
        clean_name = "not_tobias"
      elsif alias_name.downcase == "sam" and (self.first_name.downcase != "sam" or self.last_name.downcase != "smoot")
        clean_name = "not_sam"
      elsif alias_name.downcase == "chris" and self.last_name != "Bailey"
        clean_name = "not_chris"
      elsif alias_name.downcase == "josh" and self.last_name != "Peek"
        clean_name = "not_josh"
      elsif alias_name.downcase == "tobi" and self.last_name == "Schlottke"
        clean_name = "not_tobi"
      end
    end
    return clean_name
  end
  
  def recalculate_full_rank
    self.rank.blank? ? MAX_RANK : self.rank.to_i
    bonus = self.rank < 100 ? TOP_100_WWR_BONUS : 0 if not self.rank.blank?
    core_contrib_bonus = self.core_contributor ? 2500 : 0
    (MAX_RANK - self.rank) + (self.github_watchers * GITHUB_WATCHER_POINTS) + bonus + core_contrib_bonus
  end
  
  
  def retrieve_github_repos
    repos = []

    nicks_to_use = clean_nicknames
    nicks_to_use.each do |nickname|
      begin
        nickname = cleanse_bad_aliases(nickname)
        nickname.strip!
        github_user = GitHub::API.user(nickname)
        repos = repos + github_user.repositories
      rescue Exception => ex
        puts "error geting github repo, #{ex}"
      end
    end

    repos ||= []
  end
  
  private
  
  

  def valid_for_github?
    nickname and (not nickname.blank?) and nickname.upcase != "NONE"
  end
  
  def default_rank
    rank = 9999 if rank.blank?
  end
  
end


