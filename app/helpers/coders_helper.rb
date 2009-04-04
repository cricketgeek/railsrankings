module CodersHelper
    
  def page_index
    if params[:page]
      params[:page].to_i == 1 ? 1 : (SEARCH_PER_PAGE * (params[:page].to_i - 1)) + 1
    else
      return 1
    end
  end
  
  def should_show_text_ad?(index)
    index == (SEARCH_PER_PAGE - 1)
  end
  
  def company_clipped(coder)
    coder.company_name ? coder.company_name.slice(0..20) : ""
  end
  
  def recommendation_url(coder)    
    coder.profile_url.sub("http://www.workingwithrails.com/","http://www.workingwithrails.com/recommendation/new/")
  end
  
  def show_repo_name(repo)
    repo && repo.name ? link_to(repo.name,repo.url, :target => "_new") : "unknown"
  end
  
  def show_repo_points(repo)
    repo ? (repo.watchers * GITHUB_WATCHER_POINTS) : 0
  end

  def available_for_hire?(coder)
    coder.is_available_for_hire ? "Available for hire at the moment." : "Not available for hire, a bit busy just now."
  end
  
  def is_core_contributor?(coder)
    coder.core_contributor ? "Yes" : "No"
  end
  
  def is_core_team?(coder)
    coder.core_team_member ? "Yes" : "No"
  end
  
  def rails_core_status(coder)
    if coder.core_team_member
      "Rails Core Team Member"
    elsif coder.core_contributor
      "Rails Core Contributor"
    else
      ""
    end
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

  def show_company_name(company)
    company.blank? ? "Unknown" : link_to("#{company}", coders_path(:search => company))
  end
  
  def alternate_row_color(index)
    (index % 2) == 0 ? "result odd" : "result"
  end
  
  def show_coder_name(coder)
    link_to(coder.full_name,coder_path(coder))
  end
  
  def coder_metadata(coders)
    coders = @coders.collect { |coder| coder.full_name }
    coders.join(",")
  end
  
  def determine_rank_for_paging(index)
    params[:page] == "1" ? index + 1 : (params[:page].to_i - 1) * TOP_PAGES_PER + index + 1
  end
end
