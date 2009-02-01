# == Schema Information
# Schema version: 20090127025441
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  lat        :string(255)
#  long       :string(255)
#  coder_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
    has_many :coders
    
    validates_uniqueness_of :name
    validates_presence_of :name
    
end
