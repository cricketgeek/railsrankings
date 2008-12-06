
namespace :wwr do
  namespace :remote do
    desc "Load data from the WWR website"
    task :load => :environment do
      
      wwr_scraper = WWRScraper.new
      #wwr_scraper.process_main_popular_page
      wwr_scraper.process_using_seed_data
      
    end
  end
end