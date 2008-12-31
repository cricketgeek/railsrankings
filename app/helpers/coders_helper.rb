module CodersHelper
  
  def format_image_path(path)
    path = "/images/profile.png" if path and path.include?("images/profile.png")
    path
  end
  
  def page_index
    if params[:page]
      params[:page].to_i == 1 ? 1 : (SEARCH_PER_PAGE * (params[:page].to_i - 1)) + 1
    else
      return 1
    end
  end
  
  def company_clipped(coder)
    coder.company_name ? coder.company_name.slice(0..20) : ""
  end
  
  def recommendation_url(coder)    
    coder.profile_url.sub("http://www.workingwithrails.com/","http://www.workingwithrails.com/recommendation/new/")
  end
  
  def show_rank(coder)
    coder.rank < MAX_RANK ? coder.rank : "nil"
  end
  
  def show_delta(coder)
    return "" if coder.nil? or coder.delta.nil? or coder.delta == 0
    case 
    when coder.delta > 0
      "<span class='green bolder'>(+#{coder.delta})</span>"
    when coder.delta < 0
      "<span class='red bolder'>(#{coder.delta})</span>"      
    end
  end
  
  def show_city_name(city)
    city.blank? ? "Unknown location" : city
  end

  def show_company_name(company)
    company.blank? ? "Unknown" : company
  end
  
  def alternate_row_color(index)
    (index % 2) == 0 ? "user greybg" : "user"
  end
  
end
