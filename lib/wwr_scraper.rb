require 'hpricot'
require 'open-uri'

class WWRScraper
  PROCESS_UPDATES = true
  WWR_BASE_URL = "http://www.workingwithrails.com"
  attr_accessor :processed_urls
  @@logger = RAILS_DEFAULT_LOGGER
  
  
  def initialize
    @processed_urls = {}
    @crawling = true
    @rails_rankings = []
  end
  
  def process_using_name_browse_pages
    @crawling = false
    base_page_url = open("http://www.workingwithrails.com/browse/people/name")
    doc = Hpricot(base_page_url)
    doc.search('#Main/a').each do |letter_page|
      page_url = "#{WWR_BASE_URL}#{letter_page.get_attribute("href")}"
      puts "================================================================"
      puts "processing #{page_url} next"
      puts "================================================================"
      process_name_page(page_url)
    end
    base_page_url.close
    remove_phony_chacon
    output_rankings
  end
    
  def process_name_browse_by_letter(letter)
    @crawling = false
    process_name_page("http://www.workingwithrails.com/browse/people/name/#{letter}")
    remove_phony_chacon if letter == 'S' or letter == 's'
  end
  
  def reprocess_for_one_person(profile_url)
    @crawling = false
    process_profile_page(profile_url)
    rerun_rankings
  end
  
  def rerun_rankings
    @rails_rankings = Coder.all
    output_rankings    
  end
  
  def process_main_popular_page
    @crawling = false
    main_open_url = open("http://www.workingwithrails.com/browse/popular/people")
    doc = Hpricot(main_open_url)
    doc.search('#Main/table/tr/td/a').each do |prof_url|
      next_prof_url = prof_url.get_attribute("href")
      puts "==================================="
      puts "pulling #{next_prof_url} to update coder"
      process_profile_page(next_prof_url)
    end
    main_open_url.close
    remove_phony_chacon
    output_rankings
  end
  
  
  def process_using_seed_data
    @crawling = false
    @@logger.info "processing based on seed data"
    
    processing_array = [
      "http://www.workingwithrails.com/person/6086-bj-rn-wolf",
      "http://www.workingwithrails.com/person/5391-obie-fernandez",
      "http://www.workingwithrails.com/person/5323-jeremy-kemper",
      "http://www.workingwithrails.com/person/8677-sam-smoot",
      "http://www.workingwithrails.com/person/6962-justin-palmer",
      "http://www.workingwithrails.com/person/5554-pat-allan",
      "http://www.workingwithrails.com/person/6290-steven-a-bristol",      
      "http://www.workingwithrails.com/person/5380-mike-clark",
      "http://www.workingwithrails.com/person/5414-sam-stephenson",
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
      "http://www.workingwithrails.com/person/871-jim-weirich",
      "http://www.workingwithrails.com/person/13437-luigi-montanez",
      "http://www.workingwithrails.com/person/2941-andrew-stone",
      "http://www.workingwithrails.com/person/9252-hank-beaver",      
      "http://www.workingwithrails.com/person/12062-jonathan-nelson",
      "http://www.workingwithrails.com/person/14858-samuel-sayer"
    ]
    processing_array.each do |url_to_process|
      process_profile_page(url_to_process)
    end
    
  end
  
  def output_rankings
    @rails_rankings.sort!
     
    @rails_rankings.each_with_index do |coder,index|
      coder.railsrank = index + 1
      coder.save
      puts "coder #{coder.full_name} is RRanked #{index} with a full rank of #{coder.full_rank}"
    end
  end
  
  private
  
  def process_name_page(page)
    name_page_url = open(page)
    doc = Hpricot(name_page_url)
    doc.search("ul.entry-list/li/a").each do |profile_url|
      process_profile_page(profile_url.get_attribute("href"))
    end
    name_page_url.close
  end
  
  def remove_phony_chacon
    coders = Coder.find(:all,:conditions => "last_name = 'Chacon'")
    if coders.size == 2
      coder = coders.last
      coder.delete
    end
  end
  
  def should_process_url?(url)
    coder = Coder.find_by_profile_url(url)
    coder.nil? or PROCESS_UPDATES
  end
  
  def normalize_location(location)
    
    @locations = {"norcross"  =>  "Atlanta", "norcross, ga" => "Atlanta",
      "atlanta, ga" => "Atlanta", "atlanta ga" => "Atlanta", "atlanta georgia" => "Atlanta","atlanta, georgia" => "Atlanta",
      "decatur, ga" => "Atlanta", "decatur" => "Atlanta","greater atlanta area, georgia" => "Atlanta", "chicago, il" => "Chicago","wheaton, il" => "Chicago",
      "chicago, illinois" => "Chicago","chicago il" => "Chicago", "san francisco, ca" => "San Francisco","san francisco ca" => "San Francisco",
      "boston, ma" => "Boston","boston ma" => "Boston", "austin, tx" => "Austin","austin tx" => "Austin", "jacksonville, fl" => "Jacksonville",
      "jacksonville/ fl" => "Jacksonville", "jacksonville, florida" => "Jacksonville",
      "rio de janeiro / rj" => "Rio de Janeiro","austin, tx, usa" => "Austin",
      "austin, texas" => "Austin","austin / texas" => "Austin","austin (texas)" => "Austin",
      "london" => "London", "london, uk" => "London", "seattle, wa" => "Seattle", "portland, or" => "Portland",
      "san diego, ca" => "San Diego","san diego, usa" => "San Diego","new york city" => "New York City", 
      "new york, ny" => "New York City", "new york" => "New York City", "nyc" => "New York City", 
      "portland, oregon" => "Portland", "portland or" => "Portland","toronto, ontario" => "Toronto",
      "denver, co" => "Denver", "denver, colorado" => "Denver", "nashville, tn" => "Nashville",
      "los angeles, ca" => "Los Angeles", "los angeles / california" => "Los Angeles", "brooklyn, ny" => "New York City",
      "orlando, fl" => "Orlando", "orlando, florida" => "Orlando", "berkeley, ca" => "San Francisco", "cambridge, ma" => "Boston",
      "washington dc" => "Washington, DC", "washington dc area" => "Washington, DC", "toronto (ontario)" => "Toronto",
      "washington, d.c." => "Washington, DC","são paulo, sp" => "São Paulo",
      "São Paulo - SP" => "São Paulo", "winchester" => "Southampton, UK",
      "hamburg, germany" => "Hamburg", "montreal / quebec" => "Montreal",
      "longmont, co" => "Denver", "dallas, tx" => "Dallas", "dallas tx" => "Dallas",
      "chapel hill, nc" => "Chapel Hill", "chapel hill, north carolina" => "Chapel Hill", "Chapel Hill NC" => "Chapel Hill",
      "stillwater, oklahoma" => "Stillwater", "stillwater, ok" => "Stillwater, Oklahoma",
      "columbus, ohio" => "Columbus, OH", "baltimore/md" => "Baltimore", "baltimore, md" => "Baltimore",
      "baltimore md" => "Baltimore", "cracow" => "Kraków", "krakow" => "Kraków", 
      "kansas city, mo, usa" => "Kansas City", "kansas city, mo" => "Kansas City","kansas city mo" => "Kansas City",
      "santa barabara" =>"Santa Barbara", "Santa Barbara, CA" => "Santa Barbara", "Santa Barbara, California" => "Santa Barbara",
      "winnipeg, manitoba" => "Winnipeg"
      
     }
    
    return @locations[location.downcase] if @locations[location.downcase]
    return location
    
  end
  
  def normalize_company_name(company)
    @companies = {"active reload, llc." => "Active Reload","thoughtworks, inc." => "ThoughtWorks",
      "atlantic dominion solutions, llc" => "Atlantic Dominion Solutions",
      "37 signals" => "37signals","consumer source inc" => "Primedia", 
      "intridea, inc" => "Intridea"}
    
    return @companies[company.downcase] if @companies[company.downcase]
    return company
  end
  
  def process_recommendations(full_recommendation_url,coder)
    recommendations = [] 
    recommender_url_doc = open(full_recommendation_url)
    rec_doc = Hpricot(recommender_url_doc)
    rec_doc.search('#recommendations/tr/td.who-content').each do |rec_link|
      recommender_link = rec_link.search('a').attr('href')
      recommendations << {:profile_link => recommender_link,:name => rec_link.inner_html}
      begin
        process_profile_page(recommender_link) if should_process_url?(recommender_link)
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
      begin
        open_url = open(url)
        doc = Hpricot(open_url)
        wwr_id = url.split("/").last
        name = doc.search('h2.item-title').inner_html.lstrip.rstrip
        name = name.titleize.split(' ')
        first_name = name[0].gsub("."," ")
        last_name = "#{name[1..(name.length - 1)]}".gsub("."," ") if name.size > 1
        location = normalize_location(doc.search('span.locality').inner_html)
        @@logger.info "name: #{name} location is #{location}"
        if doc.at("#person-about-summary/p/a.url")
          website = doc.search('#person-about-summary/p/a.url').attr('href')
        end
        # email = doc.search('#person-further-info/a').inner_html
        # puts "email is #{email}"
        #puts doc.at('img.photo')
        img_url_el = doc.search('img.photo')
        img_url = img_url_el.attr('src') if img_url_el.any?
        company_name = normalize_company_name(doc.search('td/a.organization_name').inner_html)
        country_name = doc.search('a.country-name').inner_html
        nickname = doc.search('td.nickname').inner_html      
        rank = doc.search('div/a[@href="http://www.workingwithrails.com/browse/popular/people"]').inner_html
        rank = MAX_RANK if rank.blank?
        
        is_available_for_hire = doc.at("a[@href='/person/#{wwr_id}/enquire/new']") != nil

        recs_url = url.sub("http://www.workingwithrails.com/", "http://www.workingwithrails.com/recommendation/for/")
        recs = doc.search("#person-recommendation-for-summary/h3/a[@href='#{recs_url}']").inner_html
        coder = Coder.find_by_profile_url(url)
        coder = Coder.new if coder.nil?
        coder.is_available_for_hire = is_available_for_hire
        puts "is available for hire" if is_available_for_hire
        coder.nickname = nickname
        coder.first_name = first_name
        coder.last_name = last_name
        rails_core_contrib_img = doc.at("img[@alt='rails core contributor']")
        coder.core_contributor = !rails_core_contrib_img.nil?
        puts "#{last_name} is a core contrib" if coder.core_contributor
        add_known_aliases(coder)
        save_github_info(coder)
      
        if not rank.blank? and rank.to_i < MAX_RANK
          delta = (coder.rank.to_i - rank.to_i)
          puts "rank was #{coder.rank} delta was #{delta}"
        end
      
        coder.full_rank = calculate_full_rank(coder)
        coder.update_attributes(:website => website,
                  :image_path => img_url,:rank => rank, :city => location, 
                  :profile_url => url, :company_name => company_name,
                  :country => country_name,
                  :recommendation_count  => recs.to_i,
                  :delta => delta)
    
        coder.save
        
        if coder.valid?
          add_to_rails_rank(coder)
        else
          @@logger.error "couldn't save coder because #{coder.errors.inspect}" if not coder.valid?
        end
        
        crawl_recommendations(coder,url) if @crawling
        open_url.close
      rescue Exception => ex
        @@logger.error("FFFAIL: #{ex} while processing #{url}")
      end
    end
  end
  
  def add_known_aliases(coder)
    if coder.first_name == "David" and coder.last_name == "Chelimsky"
      coder.nickname = "dchelimsky"
      return
    end
    
    if coder.first_name == "Sam" and coder.last_name == "Smoot"
      coder.nickname = "sam"
      return
    end
    
  end

  def crawl_recommendations(coder,url)
    full_recommendation_url = url.sub("http://www.workingwithrails.com","http://www.workingwithrails.com/recommendation/for")
    process_recommendations(full_recommendation_url,coder)
  end
  
  def calculate_full_rank(coder)
    coder.recalculate_full_rank
  end
  
  def add_to_rails_rank(coder)
    @rails_rankings << coder
  end
  
  def save_github_info(coder)
    watchers = 0
    github_url = ""
    coder.retrieve_github_repos.each do |repo|
      github_repo = coder.github_repos.find_by_name(repo.name)
      github_repo.commits.delete_all if github_repo
      github_repo ||= github_repo = coder.github_repos.build
      
      puts "updating github repo #{repo.name} by #{coder.full_name} to have #{repo.watchers} watchers"
      watchers += (repo.watchers - 1)
      github_url = repo.owner
      
      github_repo.description = repo.description
      github_repo.watchers = (repo.watchers - 1)
      github_repo.name = repo.name
      github_repo.url = repo.url
      github_repo.forked = repo.forked
      github_repo.forks = repo.forks
      github_repo.save if coder.new_record?
      
      save_commits(github_repo,repo.commits.first(10))
    end
    
    coder.github_watchers = watchers
    coder.github_url = "http://www.github.com/#{github_url}" if github_url.length > 0
    coder.save
  end
  
  def save_commits(github_repo,commits)
    commits.each_with_index do |commit,index|
      new_commit = github_repo.commits.build
      new_commit.author = commit.author.name
      new_commit.commit_sha = commit.id
      new_commit.user = commit.user
      new_commit.message = commit.message
      new_commit.committed_date = commit.committed_date
      new_commit.github_repo = github_repo
      github_repo.commits << new_commit
    end
    github_repo.save
  end
  
end