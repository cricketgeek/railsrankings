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
    coder.railsrank < MAX_RANK ? coder.railsrank : "nil"
  end
  
  def available_for_hire?(coder)
    coder.is_available_for_hire ? "You can try, kind sir." : "No, too busy at the moment"
  end
  
  def is_core_contributor?(coder)
    coder.core_contributor ? "Yes" : "No"
  end
  
  def show_delta(coder)
    return "" if coder.nil? or coder.delta.nil? or coder.delta == 0
    case 
    when coder.delta > 0
      "<span class='positive'>+#{coder.delta}</span>"
    when coder.delta < 0
      "<span class='negative'>#{coder.delta}</span>"      
    end
  end
  
  def show_city_name(city)
    city.blank? ? "Unknown location" : link_to("#{city}", coders_path(:search => city))
  end

  def show_company_name(company)
    company.blank? ? "Unknown" : link_to("#{company}", coders_path(:search => company))
  end
  
  def alternate_row_color(index)
    (index % 2) == 0 ? "user greybg" : "user"
  end
  
  def show_coder_name(coder)
    link_to(coder.full_name,coder_path(coder))
  end
  
  def coder_metadata(coders)
    coders = @coders.collect { |coder| coder.full_name }
    coders.join(",")
  end
  
end
