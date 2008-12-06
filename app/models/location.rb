class Location < ActiveRecord::Base
    has_many :coders
    
    validates_uniqueness_of :name
    validates_presence_of :name
    
end
