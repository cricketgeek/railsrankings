require 'hpricot'
require 'open-uri'

class WWRScraper
  PROCESS_UPDATES = true
  attr_accessor :processed_urls
  
  def initialize
    @processed_urls = {}
  end
  
  def process_using_seed_data
    
    puts "processing based on seed data"
    
    processing_array = [
      "http://www.workingwithrails.com/person/5236-charles-brian-quinn",
     "http://www.workingwithrails.com/person/4343-brendan-lim",
     "http://www.workingwithrails.com/person/2892-akhil-bansal",
     "http://www.workingwithrails.com/person/9530-jason-lee",
     "http://www.workingwithrails.com/person/7440-lindsay-ucci",
     "http://www.workingwithrails.com/person/9784-colin-harris",
     "http://www.workingwithrails.com/person/7241-craig-webster",
     "http://www.workingwithrails.com/person/5957-cheah-chu-yeow",
     "http://www.workingwithrails.com/person/12003-les-hill",
     "http://www.workingwithrails.com/person/5246-david-heinemeier-hansson",
     "http://www.workingwithrails.com/person/11125-asa-wilson",
     "http://www.workingwithrails.com/person/2941-andrew-stone",
     "http://www.workingwithrails.com/person/9252-hank-beaver",
     "http://www.workingwithrails.com/person/5639-amy-hoy",
     "http://www.workingwithrails.com/person/5306-james-duncan-davidson",      
     "http://www.workingwithrails.com/person/12633-mark-jones",
     "http://www.workingwithrails.com/person/13224-collin-vandyck",
     "http://www.workingwithrails.com/person/15297-zack-adams",
     "http://www.workingwithrails.com/person/15141-tommy-campbell", 
     "http://www.workingwithrails.com/person/5414-sam-stephenson",
     "http://www.workingwithrails.com/person/3942-charles-nutter",
     "http://www.workingwithrails.com/person/5421-ezra-zygmuntowicz",
     "http://www.workingwithrails.com/person/5426-dr-nic-williams",
     "http://www.workingwithrails.com/person/4987-michael-koziarski",
     "http://www.workingwithrails.com/person/6085-eric-hodel",
     "http://www.workingwithrails.com/person/5595-stuart-halloway",
     "http://www.workingwithrails.com/person/5296-geoffrey-grosenbach",
     "http://www.workingwithrails.com/person/7739-evan-weaver",
     "http://www.workingwithrails.com/person/6629-jeremy-mcanally",
     "http://www.workingwithrails.com/person/12253-nathen-grass",
     "http://www.workingwithrails.com/person/5416-rick-olson",
     "http://www.workingwithrails.com/person/5260-dave-thomas",
     "http://www.workingwithrails.com/person/5646--whytheluckystiff",
     "http://www.workingwithrails.com/person/6766-neal-ford",
     "http://www.workingwithrails.com/person/6491-ryan-bates",
     "http://www.workingwithrails.com/person/7192-wayne-e-seguin",
     "http://www.workingwithrails.com/person/4769-tobias-luetke",
     "http://www.workingwithrails.com/person/871-jim-weirich"
    ]
    processing_array.each do |url_to_process|
      process_profile_page(url_to_process)
    end
    
  end
  
  def should_process_url?(url)
    coder = Coder.find_by_profile_url(url)
    coder.nil? or PROCESS_UPDATES
  end
  
  def normalize_location(location)
    
    @locations = {"norcross"  =>  "Atlanta", 
      "atlanta, ga" => "Atlanta", "atlanta ga" => "Atlanta", "atlanta georgia" => "Atlanta",
      "decatur, ga" => "Atlanta", "decatur" => "Atlanta","chicago, IL" => "Chicago","wheaton, il" => "Chicago",
      "chicago, illinois" => "Chicago"
    }
    
    return @locations[location.downcase] if @locations[location.downcase]
    return location
    
  end
  
  def process_recommendations(full_recommendation_url,coder)
    recommendations = [] 
    recommender_url_doc = open(full_recommendation_url)
    rec_doc = Hpricot(recommender_url_doc)
    rec_doc.search('#recommendations/tr/td.who-content').each do |rec_link|
      #puts "found another recommendation, from #{rec_link.inner_html}"
      recommender_link = rec_link.search('a').attr('href')
      recommendations << {:profile_link => recommender_link,:name => rec_link.inner_html}
      begin
        process_profile_page(recommender_link) if should_process_url?(recommender_link) #and (coder.rank and coder.rank.to_i > 300)
        coder.recommendation_count = recommendations.size
        coder.save
      rescue Exception => ex
        puts "#{ex.message} for url: #{full_recommendation_url}"
      end
    end
    recommender_url_doc.close
  end
  
  def process_profile_page(url)
    
    if not @processed_urls[url]
      @processed_urls[url] = url
      puts "processing profile: #{url}"
      open_url = open(url)
      doc = Hpricot(open_url)
      name = doc.search('h2.item-title').inner_html.lstrip.rstrip
      name = name.titleize.split(' ')
      first_name = name[0]
      last_name = name[1,name.length].join(" ")
      puts "name: #{name}"
      location = normalize_location(doc.search('span.locality').inner_html)
      puts "location is #{location}"
      website = doc.search('#person-about-summary/a.url').inner_html
      img_url = doc.search('img.photo').attr('src')
      company_name = doc.search('td/a.organization_name').inner_html
      country_name = doc.search('a.country-name').inner_html
      nickname = doc.search('td.nickname').inner_html
      puts "nickname is: #{nickname}"
      
      rank = doc.search('div/a[@href="http://www.workingwithrails.com/browse/popular/people"]').inner_html
      rank = 9999 if rank.blank?
      puts "rank is #{rank.to_i}"
      
      #TODO: retain authority lines
      # doc.search('ul.authority/li.tick').each do |authority|
      #   
      # end
      coder = Coder.find_by_profile_url(url)
      puts "updating #{coder.full_name}" if coder
      coder = Coder.new if coder.nil?
      
      coder.update_attributes(:last_name => last_name,:first_name => first_name,:website => website,
                :image_path => img_url,:rank => rank, :city => location, 
                :profile_url => url, :company_name => company_name,
                :country => country_name, :nickname => nickname)
    
      coder.save
      puts "couldn't save coder because #{coder.errors.inspect}" if not coder.valid?
    
      full_recommendation_url = url.sub("http://www.workingwithrails.com","http://www.workingwithrails.com/recommendation/for")
      process_recommendations(full_recommendation_url,coder)      
      open_url.close
    end
  end
  
  def process_main_popular_page
    main_open_url = open("http://www.workingwithrails.com/browse/popular/people")
    doc = Hpricot(main_open_url)
    doc.search('#Main/table/tr/td/a').each do |prof_url|
      #puts prof_url.get_attribute("href")
      process_profile_page(prof_url.get_attribute("href"))
    end
    main_open_url.close
  end
  
  
end