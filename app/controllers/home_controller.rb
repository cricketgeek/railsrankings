class HomeController < ApplicationController

  before_filter :build_top_items
  
  def index
  end

end