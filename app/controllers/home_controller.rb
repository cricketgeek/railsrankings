class HomeController < ApplicationController

  def index
  
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