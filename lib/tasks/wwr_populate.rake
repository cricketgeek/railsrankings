
namespace :wwr do
  namespace :remote do
    desc "Load data from the WWR website"
    task :load => :environment do
      RAILS_ENV="production"
      wwr_scraper = WWRScraper.new
      wwr_scraper.process_using_seed_data
      wwr_scraper.process_main_popular_page
    end
    
    desc "loading data starting with the browse people letter pages"
    task :load_all => :environment do
      wwr_scraper = WWRScraper.new
      wwr_scraper.process_using_name_browse_pages
    end
    
  end
end