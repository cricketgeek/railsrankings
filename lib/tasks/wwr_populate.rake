
namespace :wwr do
  namespace :remote do
    desc "Load data from the WWR website"
    task :load => :environment do
      wwr_scraper = WWRScraper.new
      wwr_scraper.process_using_seed_data
      wwr_scraper.process_main_popular_page
    end
    
    desc "loading data starting with the browse people letter pages"
    task :load_all => :environment do
      wwr_scraper = WWRScraper.new
      wwr_scraper.process_using_name_browse_pages
    end

    desc "load data by a specific first letter of the first name on WWR"
    task :load_by_letter, [:letter] => :environment do
      unless ENV.include?("letter")
          raise "usage: rake letter=[A-Z]" 
      end
      letter = ENV['letter']
      puts "processing just letter #{letter} page"
      wwr_scraper = WWRScraper.new
      wwr_scraper.process_name_browse_by_letter(letter)
    end
  end
end