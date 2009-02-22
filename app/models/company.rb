# == Schema Information
# Schema version: 20090221173936
#
# Table name: companies
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  location     :string(255)
#  logo_path    :string(255)
#  coders_count :integer(4)
#  full_rank    :integer(4)
#  railsrank    :integer(4)
#  wwr_profile  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Company < ActiveRecord::Base
  
  has_many :coders
  
end
