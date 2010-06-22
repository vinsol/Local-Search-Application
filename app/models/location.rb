# == Schema Information
# Schema version: 20100618113518
#
# Table name: locations
#
#  id         :integer(4)      not null, primary key
#  location   :string(255)
#  created_at :datetime
#  updated_at :datetime
#  city_id    :integer(4)
#

class Location < ActiveRecord::Base
  validates_presence_of :location, :city_id
  belongs_to :city
end
