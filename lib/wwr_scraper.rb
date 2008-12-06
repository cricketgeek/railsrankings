require 'hpricot'
require 'open-uri'

class WWRScraper
  PROCESS_UPDATES = true
  LEVELS_TO_PARSE = 55
  attr_accessor :processed_urls,:levels_parsed
  
  def initialize
    @processed_urls = {}
    @levels_parsed = 0
  end
  
  def process_using_seed_data
    
    puts "processing based on seed data"
    
    processing_array = [
      "http://workingwithrails.com/person/2892-akhil-bansal",
    #  "http://workingwithrails.com/person/9530-jason-lee",
      "http://workingwithrails.com/person/13224-collin-vandyck",
    # "http://workingwithrails.com/person/7440-lindsay-ucci",
    #  "http://workingwithrails.com/person/9784-colin-harris",
    #  "http://workingwithrails.com/person/7241-craig-webster",
    #  "http://workingwithrails.com/person/5957-cheah-chu-yeow",
    #  "http://workingwithrails.com/person/12003-les-hill",
    "http://workingwithrails.com/person/5246-david-heinemeier-hansson",
    #{}"http://www.workingwithrails.com/person/9252-hank-beaver"
    #{}"http://workingwithrails.com/person/5639-amy-hoy",
    #{}"http://workingwithrails.com/person/5306-james-duncan-davidson",      
    "http://workingwithrails.com/person/12633-mark-jones",
    #{}"http://www.workingwithrails.com/person/5414-sam-stephenson",
    #{}"http://workingwithrails.com/person/3942-charles-nutter",
    #{}"http://workingwithrails.com/person/5421-ezra-zygmuntowicz",
    #{}"http://workingwithrails.com/person/5426-dr-nic-williams",
    #{}"http://workingwithrails.com/person/4987-michael-koziarski",
    #{}"http://workingwithrails.com/person/6085-eric-hodel",
    #{}"http://workingwithrails.com/person/5595-stuart-halloway",
    #{}"http://workingwithrails.com/person/5296-geoffrey-grosenbach",
    #{}"http://workingwithrails.com/person/7739-evan-weaver",
    #{}"http://workingwithrails.com/person/6629-jeremy-mcanally",
    #{}"http://workingwithrails.com/person/12253-nathen-grass",
    #{}"http://workingwithrails.com/person/5416-rick-olson",
    #{}"http://workingwithrails.com/person/5260-dave-thomas",
    #{}"http://workingwithrails.com/person/5646--whytheluckystiff",
    #{}"http://workingwithrails.com/person/6766-neal-ford",
    "http://workingwithrails.com/person/6491-ryan-bates",
    #  "http://workingwithrails.com/person/7192-wayne-e-seguin",
    "http://workingwithrails.com/person/4769-tobias-luetke",
    "http://workingwithrails.com/person/871-jim-weirich"
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
    #return if @levels_parsed > LEVELS_TO_PARSE
    @levels_parsed += 1   
    puts "#{@levels_parsed} levels down the rabbit hole"
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
      
      rank = doc.search('div/a[@href="http://workingwithrails.com/browse/popular/people"]').inner_html
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
                :profile_url => url)
    
      coder.save
      puts "couldn't save coder because #{coder.errors.inspect}" if not coder.valid?
    
      full_recommendation_url = url.sub("http://workingwithrails.com","http://workingwithrails.com/recommendation/for")
      process_recommendations(full_recommendation_url,coder)      
      open_url.close
    end
  end
  
  def process_main_popular_page
    main_open_url = open("http://workingwithrails.com/browse/popular/people")
    doc = Hpricot(main_open_url)
    doc.search('#Main/table/tr/td/a').each do |prof_url|
      #puts prof_url.get_attribute("href")
      process_profile_page(prof_url.get_attribute("href"))
    end
    main_open_url.close
  end
  
  
end