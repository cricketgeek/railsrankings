require 'hpricot'
require 'open-uri'

class WorkingProfile
  attr_accessor :doc, :url
  
  def initialize(profile_url)
    @url = profile_url
    @open_url = open(profile_url)
    @doc = Hpricot(@open_url)
  end
  
  def normalize_company_name(company)
    
    @companies ||= {"active reload, llc." => "Active Reload","thoughtworks, inc." => "ThoughtWorks",
      "atlantic dominion solutions, llc" => "Atlantic Dominion Solutions",
      "37 signals" => "37signals","consumer source inc" => "Primedia", 
      "intridea, inc" => "Intridea",
      "entp.com" => "ENTP", "entp" => "ENTP"}
    
    return @companies[company.downcase] if @companies[company.downcase]
    return company
  end
  
  def normalize_location(location)
    @locations ||= {
      "norcross"  =>  "Atlanta", "norcross, ga" => "Atlanta",
      "atlanta, ga" => "Atlanta", "atlanta ga" => "Atlanta", "atlana ga" => "Atlanta",
      "atlanta georgia" => "Atlanta", "atlanta, georgia" => "Atlanta",
      "decatur, ga" => "Atlanta", "decatur" => "Atlanta",
      "greater atlanta area, georgia" => "Atlanta", 
      "chicago, il" => "Chicago","wheaton, il" => "Chicago","chicago, illinois" => "Chicago","chicago il" => "Chicago",
      "chicago / il" => "Chicago",
      "san francisco, ca" => "San Francisco","san francisco ca" => "San Francisco", "san francisco bay area" => "San Francisco",
      "berkeley, ca" => "San Francisco","san francisco, california" => "San Francisco", "san francisco / ca" => "San Francisco",
      "san francisco, usa" => "San Francisco",
      "boston, ma" => "Boston","boston ma" => "Boston", "boston, massachusetts" => "Boston", "boston/ma" => "Boston",
      "austin, tx" => "Austin","austin tx" => "Austin", "austin, tx, usa" => "Austin",
      "austin, texas" => "Austin","austin / texas" => "Austin","austin (texas)" => "Austin", "austin,, tx" => "Austin",
      "jacksonville, fl" => "Jacksonville","jacksonville/ fl" => "Jacksonville", "jacksonville, florida" => "Jacksonville",
      "jacksonville beach, fl" => "Jacksonville",
      "rio de janeiro / rj" => "Rio de Janeiro",
      "london" => "London", "london, uk" => "London", "london / london / uk " => "London",
      "seattle, wa" => "Seattle", "seattle, washington"  => "Seattle",
      "portland, or" => "Portland","portland, oregon" => "Portland", "portland or" => "Portland",
      "san diego, ca" => "San Diego","san diego, usa" => "San Diego",
      "new york city" => "New York City", "new york, ny" => "New York City", "new york" => "New York City", "nyc" => "New York City",
      "brooklyn, ny" => "New York City","new york city, ny" => "New York City", "nyc metro" => "New York City",
      "toronto, ontario" => "Toronto","toronto, on" => "Toronto","toronto / ontario" => "Toronto",
      "denver, co" => "Denver", "denver, colorado" => "Denver", "longmont, co" => "Denver", "longmont, colorado" => "Denver",
      "nashville, tn" => "Nashville",
      "los angeles, ca" => "Los Angeles", "los angeles / california" => "Los Angeles", "los angeles, california" => "Los Angeles",
      "orlando, fl" => "Orlando", "orlando, florida" => "Orlando", "cambridge, ma" => "Boston",
      "washington dc" => "Washington, DC", "washington dc area" => "Washington, DC", "toronto (ontario)" => "Toronto",
      "washington, d.c." => "Washington, DC","washington d.c. metro area" => "Washington, DC","dc area" => "Washington, DC",
      "São Paulo - SP" => "São Paulo", "sao paulo/sp" => "São Paulo", "são paulo, sp" => "São Paulo",
      "winchester" => "Southampton, UK",
      "hamburg, germany" => "Hamburg", 
      "montreal / quebec" => "Montreal","Montreal, Quebec" => "Montreal",
      "dallas, tx" => "Dallas", "dallas tx" => "Dallas","dallas, texas" => "Dallas",
      "chapel hill, nc" => "Chapel Hill", "chapel hill, north carolina" => "Chapel Hill", "Chapel Hill NC" => "Chapel Hill",
      "stillwater, oklahoma" => "Stillwater", "stillwater, ok" => "Stillwater, Oklahoma",
      "columbus, ohio" => "Columbus, OH", 
      "baltimore/md" => "Baltimore", "baltimore, md" => "Baltimore",
      "baltimore md" => "Baltimore", 
      "cracow" => "Kraków", "krakow" => "Kraków", 
      "huntsville / alabama" => "Huntsville, AL", "Huntsville / al" => "Huntsville, AL",
      "kansas city, mo, usa" => "Kansas City", "kansas city, mo" => "Kansas City","kansas city mo" => "Kansas City",
      "santa barabara" =>"Santa Barbara", "santa barbara, cA" => "Santa Barbara", "santa barbara, california" => "Santa Barbara",
      "winnipeg, manitoba" => "Winnipeg","winnipeg (mb)" => "Winnipeg",
      "raleigh, nc" => "Raleigh", "raleigh, north carolina" => "Raleigh",
      "paris, france" => "Paris", "paris, fr" => "Paris", "paris / france" => "Paris"
     }
    return @locations[location.downcase] if @locations[location.downcase]
    return location
  end
  
  def wwr_id
    @url.split("/").last
  end
  
  def name
    @name_val ||= @doc.search("h2.item-title").inner_html
    unless @name_val.nil?
      @name_val.gsub(/\n/,"").lstrip.rstrip
    end
  end
  
  def last_name
    @last_name_val ||= @doc.search("h2.item-title").inner_html
    unless @last_name_val.nil?
      raw = @last_name_val.gsub(/\n/,"").lstrip.rstrip
      raw = raw.titleize.split(' ')
      "#{raw[1..(raw.length - 1)]}".gsub("."," ")
    end
  end
  
  def first_name
    @first_name_val ||= @doc.search("h2.item-title").inner_html
    unless @first_name_val.nil?
      raw = @first_name_val.gsub(/\n/,"").lstrip.rstrip
      raw = raw.titleize.split(' ')
      raw[0].gsub("."," ")
    end    
  end
  
  def location
    normalize_location(@doc.search('span.locality').inner_html)
  end
  
  def core_contributor?
    @rails_core_contrib_img ||= @doc.at("img[@alt='rails core contributor']")
    !@rails_core_contrib_img.nil?
  end
  
  def core_team_member?
    @rails_core_team_member_img ||= @doc.at("img[@alt='rails core team member']")
    !@rails_core_team_member_img.nil?
  end
  
  def company_name
    normalize_company_name(@doc.search('td/a.organization_name').inner_html) 
  end
  
  def country_name
    @doc.search('a.country-name').inner_html
  end
  
  def recommendation_count
    @doc.search("#person-recommendation-for-summary/h3/a[@href='#{recommendations_url}']").inner_html.to_i
  end
  
  def rank
    raw_rank = @doc.search('div/a[@href="http://www.workingwithrails.com/browse/popular/people"]').inner_html    
    raw_rank.blank? ? MAX_RANK : raw_rank.to_i
  end
  
  def nickname
    @doc.search('td.nickname').inner_html  
  end
  
  def website
    if @doc.at("#person-about-summary/p/a.url")
      @doc.search('#person-about-summary/p/a.url').attr('href')
    end
  end
  
  def image_path
    @img_url_el ||= @doc.search('img.photo')
    @img_url_el.attr('src') if @img_url_el.any?
  end
  
  def is_available_for_hire?
    @doc.at("a[@href='/person/#{wwr_id}/enquire/new']") != nil
  end
  
  def close
    @open_url.close
  end
  
  private
  
  def recommendations_url
    @url.sub("http://www.workingwithrails.com/", "http://www.workingwithrails.com/recommendation/for/")
  end
  
end