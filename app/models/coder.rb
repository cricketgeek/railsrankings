class Coder < ActiveRecord::Base
  #belongs_to :location
  
  validates_uniqueness_of :profile_url
  validates_presence_of :profile_url
  
  before_create :default_rank
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  private

  def default_rank
    rank = 9999 if rank.blank?
  end
  
end


