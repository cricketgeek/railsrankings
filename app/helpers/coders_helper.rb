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
  
end
