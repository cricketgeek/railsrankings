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
      @@logger.info "processing pages for letter #{letter_page}"
      process_name_page(page_url)
    end
    base_page_url.close
    @@logger.info "done scraping profile pages"
    remove_phonies
    @@logger.info "done removing phonies"
    output_rankings
    #@@logger.info "done processing and rerunning rankings algo"
  end
    
  def process_name_browse_by_letter(letter)
    @crawling = false
    process_name_page("http://www.workingwithrails.com/browse/people/name/#{letter}")
    remove_phonies if letter == 'S' or letter == 's'
    rerun_rankings
  end
  
  def reprocess_for_one_person(profile_url)
    @crawling = false
    process_profile_page(profile_url)
    rerun_rankings
  end
  
  def rerun_rankings
    @rails_rankings = Coder.ranked
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
    remove_phonies
    rerun_rankings
  end
  
  def all_github_only
    @coders = Coder.all
    puts "Processing #{@coders.size} coders"
    @coders.each do |coder|
      #puts "Processing repos for #{coder.whole_name}"
      save_github_info(coder)
    end
  end
  
  def github_only(coder_nickname)
    @coder = Coder.find(:first, :conditions => ["whole_name= ?", coder_nickname])
    if @coder
      puts "processing coder #{@coder.whole_name} for github only"
      save_github_info(@coder)
    else
      puts "no coder by that name: #{coder_nickname}"
    end
  end
  
  def all_github_only_to_rank(rank)
    @coders = Coder.find(:all,:limit => rank,:order => "railsrank ASC")
    @coders.each do |coder|
      puts "Processing repos for #{coder.whole_name}"
      save_github_info(coder)
    end
  end
  
  def all_github_only_rank_range(start,finish)
    @coders = Coder.find(:all,:limit => finish,:offset => start,:order => "railsrank ASC")
    @coders.each do |coder|
      puts "Processing repos for #{coder.whole_name}"
      save_github_info(coder)
    end
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
    @@logger.info "running output rankings"
    #@rails_rankings.sort!
    puts "running calculations on all coders' rankings"
    @rails_rankings.each_with_index do |coder,index|
      new_rank = index + 1
      coder.delta = coder.railsrank - new_rank
      coder.railsrank = new_rank
      coder.save
    end
  end
  
  def remove_phonies
    coders = Coder.find(:all,:conditions => "last_name = 'Chacon'")
    if coders.size == 2
      coder = coders.last
      coder.delete
    end
    Coder.delete_all("last_name = 'Maccaw' and first_name = 'Alexander'")
    Coder.delete_all("first_name='Steven' AND last_name='Bristol' AND rank = 9999")
    Coder.delete_all("whole_name = 'Entered in world of RAILS'")
    
    tobias = Coder.find(:first, :conditions => "last_name='Kahre' and first_name='Tobias'")
    if tobias
      tobias.railsrank = MAX_RANK
      tobias.github_url = ""
      tobias.github_watchers = 0
      tobias.full_rank = calculate_full_rank(tobias)
      tobias.save
    end
    
    begin
      mao = Coder.find_by_("mao-dan")
      mao.delete
    rescue
    end
    
    begin
      c = Coder.find("abhijat-mahajan")
      c.delete
    rescue
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
  
  def should_process_url?(url)
    coder = Coder.find_by_profile_url(url)
    coder.nil? or PROCESS_UPDATES
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
        coder = Coder.find_by_profile_url(url)
        coder = Coder.new if coder.nil?
        wwr_profile = WorkingProfile.new(url)
        
        coder.first_name = wwr_profile.first_name
        coder.last_name = wwr_profile.last_name
        coder.whole_name = wwr_profile.name
        recs = wwr_profile.recommendation_count

        coder.profile_url = url
        coder.nickname = wwr_profile.nickname
        coder.core_contributor =  wwr_profile.core_contributor?
        coder.core_team_member =  wwr_profile.core_team_member?
        coder.is_available_for_hire = wwr_profile.is_available_for_hire?
        coder.username = build_username(coder)
        
        add_known_aliases(coder)
        #save_github_info(coder)
        
        delta = coder.rank - wwr_profile.rank if coder.rank
        coder.rank = wwr_profile.rank
        coder.full_rank = calculate_full_rank(coder)
        coder.website = wwr_profile.website
        coder.image_path = wwr_profile.image_path
        coder.city = wwr_profile.location
        company = Company.find_or_create_by_name(wwr_profile.company_name)
        coder.company_name = wwr_profile.company_name
        coder.country = wwr_profile.country_name
        coder.recommendation_count = wwr_profile.recommendation_count
        coder.delta = delta
        coder.updated = true
        coder.scraperUpdateDate = DateTime.now
        coder.save!        
        add_to_rails_rank(coder)
        #crawl_recommendations(coder,url) if @crawling
        wwr_profile.close
      rescue Exception => ex
        puts "exception #{ex}"
        @@logger.error("FFFAIL: #{ex} while processing #{url}")
      end
    end
  end
  
  def build_username(coder)
    return coder.whole_name if coder.whole_name
    return "#{coder.first_name}-#{coder.last_name}" if coder.first_name or coder.last_name
    return "unknown"
  end
  
  def process_recent_rails_commits_on_github
    rails_github_user = GitHub::API.user("rails")
    repo = rails_github_user.repositories.find { |repo| repo.name == "rails" }
    rails_repo = GithubRepo.find_or_create_by_url(repo.url)
    save_commits(rails_repo,rails_repo.commits.first(50))
    
  end
  
  def process_company(company_name, coder)
    company = @companies[company_name] || Company.find_or_create_by_name(company_name)
    if company
      repos = []
      github_user = GitHub::API.user(company)
      repos = github_user.repositories
      create_or_update_repo(company_name)
      # company.full_rank += company
      # company.save
      # @companies[company_name] = company
    end
  end
  
  def add_known_aliases(coder)
    
    if coder.first_name == "David" and coder.last_name == "Chelimsky"
      coder.nickname = "dchelimsky"
    elsif coder.first_name == "Sam" and coder.last_name == "Smoot"
      coder.nickname = "sam"
    elsif coder.first_name == "Tobias" and coder.last_name == "Luetke"
      coder.nickname = "tobi"
    elsif coder.first_name == "Tobias" and coder.last_name == "Crawley"
      coder.nickname = "tobias"
    elsif coder.first_name == "Steven" and coder.last_name == "Bristol"
      coder.nickname = "stevenbristol"
    elsif coder.first_name == "Andre" and coder.last_name == "Lewis"
      coder.nickname = "andre"
    elsif coder.first_name == "Clemens" and coder.last_name == "Kofler"
      coder.nickname = "clemens"
    elsif coder.first_name == "Mike" and coder.last_name == "Clark" and coder.profile_url == "http://www.workingwithrails.com/person/5380-mike-clark"
      coder.nickname = "clarkware"
    elsif coder.first_name == "Giles" and coder.last_name == "Bowkett"
      coder.nickname = "gilesbowkett"
    elsif coder.whole_name == "Dan Benjamin"
      coder.nickname = "dan"
    elsif coder.whole_name == "Jim Weirich"
      coder.nickname = "jimweirich"
    elsif coder.whole_name == "Jim Neath"
      coder.nickname = "jimneath"
    elsif coder.whole_name == "Jaime Bellmyer"
      coder.nickname = "bellmyer"
    elsif coder.whole_name == "Jeremy McAnally"
      coder.nickname = "jm"
    elsif coder.whole_name == "Manuel Meurer"
      coder.nickname = "manuelmeurer"
    elsif coder.whole_name == "Julius Francisco"
      coder.nickname = "baldrailers"
    elsif coder.whole_name == "Chris Herring"
      coder.nickname = "cherring"
    elsif coder.whole_name == "Andrea Salicetti"
      coder.nickname = "knightq"
    elsif coder.whole_name == "Tony Arcieri"
      coder.nickname = "tarcieri"
    elsif coder.whole_name == "Kieran P"
      coder.nickname = "KieranP"
    elsif coder.whole_name = "Mike Bailey"
      coder.nickname = "mbailey"
    elsif coder.whole_name == "Claudio Poli"
      coder.nickname = "masterkain"
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
  
  def create_or_update_repo(repo)
    github_repo = GithubRepo.find_or_create_by_url(repo.url)
    github_repo.description = repo.description
    github_repo.alias_used = repo.nickname_used
    github_repo.watchers = (repo.watchers - 1)
    github_repo.name = repo.name
    github_repo.url = repo.url
    github_repo.forked = repo.fork
    github_repo.forks = repo.forks
    return github_repo
  end
  
  def save_github_info(coder)
    watchers = 0
    github_url = ""
    coder.updated = true
    coder.scraperUpdateDate = DateTime.now
    
    coder.save
    coder.retrieve_github_repos.each do |repo|
      if GithubRepo.valid_repo_name_and_description?(repo)
        begin
          github_repo = create_or_update_repo(repo)
          github_repo.coder_id = coder.id
          Commit.delete_all(["github_repo_id = ?",github_repo.id])
          watchers += (repo.watchers - 1)
          github_repo.save
          if github_repo.valid?
            coder.github_repos << github_repo
            save_commits(github_repo,repo.commits.first(30))
          end
        rescue Exception => ex
          puts "error for repo #{repo.name}  #{ex}"
          @@logger.error("#{repo.name} busted up with error:#{ex} either accessing the repo data or getting and saving commits")
        end
      end
    end
    coder.github_watchers = watchers
    coder.github_url = "http://www.github.com/#{github_url}" if github_url.length > 0
    coder.full_rank = calculate_full_rank(coder)    
    coder.save
    @@logger.error("couldn't save coder validation errors #{coder.errors.inspect}") if !coder.valid?
  end
  
  def save_commits(github_repo,commits)
    commits.each_with_index do |commit,index|
      #puts "saving new commit #{commit.message} for github repo ID: #{github_repo.id}"
      begin
        new_commit = github_repo.commits.build
        new_commit.author = commit.author.name
        new_commit.github_repo_id = github_repo.id
        new_commit.commit_sha = commit.id
        new_commit.user = commit.user
        new_commit.message = commit.message
        new_commit.committed_date = commit.committed_date
        new_commit.github_repo_id = github_repo.id
        new_commit.save!
        github_repo.commits << new_commit
      rescue Exception => ex
        puts "error saving commit #{ex}"
        # @@logger.error "error saving commit #{ex}"
      end
    end
    github_repo.save
  end
  
end