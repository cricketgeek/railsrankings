module CodersHelper
  
  def format_image_path(path)
    path = "/images/profile.png" if path and path.include?("images/profile.png")
    path
  end
  
end
