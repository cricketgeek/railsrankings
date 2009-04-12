# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'd59b651ef4ce6957caee0dfc59f326a3'

  
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  def build_top_items
    #top 10 guys split into 2
    @top_ten_coders = Coder.top_ranked(10)
    @top_five = @top_ten_coders[0..4]
    @last_five = @top_ten_coders[5..9]
    @coders = @top_ten_coders
  
    #top 10 cities
    @top_ten_cities = Coder.cities(10)

    #top 10 companies
    @top_ten_companies = Coder.companies(10)
  
    #top 10 github repos
    @top_ten_repos = GithubRepo.popular(10)
    @repos_first_section = @top_ten_repos[0..4]
    @repos_second_section = @top_ten_repos[5..9]
  end
  
end
