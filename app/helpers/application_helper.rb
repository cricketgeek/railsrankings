# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def show_rank(coder)
    coder.railsrank < MAX_RANK ? coder.railsrank : "nil"
  end
  
  def format_image_path(path)
    path = "/images/profile.png" if path and path.include?("images/profile.png")
    path
  end
  
  def show_city_name(city)
    city.blank? ? "Unknown location" : link_to("#{city}", coders_path(:search => city))
  end
  
  def show_coder_link(coder)
    link_to(coder.full_name,coder_path(coder))
  end
  
end
