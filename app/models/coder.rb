class Coder < ActiveRecord::Base
  #belongs_to :location
  
  define_index do
    indexes [first_name,last_name], :as => :name
    indexes city
    
    has rank
  end
  
  validates_uniqueness_of :profile_url
  validates_presence_of :profile_url
  
  named_scope :ranked, :conditions => "rank is not null", :order => :rank
  
  before_create :default_rank
  
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  private

  def default_rank
    rank = 9999 if rank.blank?
  end
  
end


