module CodersHelper
  
  def format_image_path(path)
    path = "/images/profile.png" if path and path.include?("images/profile.png")
    path
  end
  
  def page_index
    if params[:page]
      params[:page].to_i == 1 ? 1 : (20 * (params[:page].to_i - 1)) + 1
    else
      return 1
    end
  end
  
end
