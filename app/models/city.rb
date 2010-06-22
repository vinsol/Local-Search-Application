# == Schema Information
# Schema version: 20100618113518
#
# Table name: cities
#
#  id         :integer(4)      not null, primary key
#  city       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class City < ActiveRecord::Base
  validates_presence_of :city
  has_many :locations
end
