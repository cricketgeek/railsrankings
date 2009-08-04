namespace :wwr do
  desc "Load data from the WWR website"
  task :load => :environment do
    wwr_scraper = WWRScraper.new
    wwr_scraper.process_using_seed_data
    wwr_scraper.process_main_popular_page
  end
  
  desc "load only the top 100 page"
  task :load_top_100 => :environment do
    wwr_scraper = WWRScraper.new
    wwr_scraper.process_main_popular_page
  end
  
  desc "loading data starting with the browse people letter pages"
  task :load_all => :environment do
    wwr_scraper = WWRScraper.new
    wwr_scraper.process_using_name_browse_pages
    Rake::Task["data_helpers:slugify"].invoke
    Rake::Task["ts:stop"].invoke
    Rake::Task["ts:index"].invoke
    Rake::Task["ts:start"].invoke
  end
  
  desc "create "
  task :export_sitemap => :environment do
    
    
  end
  
  desc "process just one profile url, re-run rankings sort"
  task :reload_one, [:profile_url] => :environment do
    unless ENV.include?("profile_url")
        raise "usage: rake profile_url=http://www.workingwithrails.com/person/8914-russell-norris" 
    end
    profile_url = ENV['profile_url']
    puts "processing just profile #{profile_url} page"
    wwr_scraper = WWRScraper.new
    wwr_scraper.reprocess_for_one_person(profile_url) 
    Rake::Task["data_helpers:slugify"].invoke
  end

  desc "re-run rankings algo"
  task :rerun_rankings => :environment do
    wwr_scraper = WWRScraper.new
    wwr_scraper.rerun_rankings
  end
  
  desc "run set of letter pages"
  task :load_by_letters => :environment do

    unless ENV.include?("letters")
      raise "usage: rake letters=A,M"
    end
    letters = ENV['letters'].split(",")
    puts letters.inspect
    wwr_scraper = WWRScraper.new      
    (letters[0]..letters[1]).each do |letter|
      wwr_scraper.process_name_browse_by_letter(letter)
    end
    Rake::Task["data_helpers:slugify"].invoke
    
  end
  
  desc "load data by a specific first letter of the first name on WWR"
  task :load_by_letter, [:letter] => :environment do
    unless ENV.include?("letter")
        raise "usage: rake letter=A" 
    end
    letter = ENV['letter']
    puts "processing just letter #{letter} page"
    wwr_scraper = WWRScraper.new
    wwr_scraper.process_name_browse_by_letter(letter)
    Rake::Task["data_helpers:slugify"].invoke
  end
  
  desc "remove bad repos and commits"
  task :cleanup  => :environment do
    repos = GithubRepo.find(:all,:conditions => "coder_id IS NULL OR name like '%django%' OR description like '%django%'")
    repos.each do |repo|
      repo.commits.delete_all
      repo.delete
    end
    Commit.delete_all("github_repo_id is NULL")
    
    wwr_scraper = WWRScraper.new
    wwr_scraper.remove_phonies
    
  end
end