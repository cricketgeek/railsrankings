# == Schema Information
# Schema version: 20091009155858
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  city       :string(255)
#  state      :string(255)
#  zip        :string(255)
#  lat        :string(255)
#  lon        :string(255)
#  coder_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  udid       :string(255)
#

class Location < ActiveRecord::Base
    belongs_to :coder
    before_create :associate_coder
    
    
    def associate_coder
      if !udid.blank?
        coder = Coder.find(:first,:conditions => ["udid = ?",self.udid])
        self.coder = coder if coder 
      end
    end
    
end
