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
  
  belongs_to :city
  before_save :geocode_location
  
  validates_presence_of :location, :city_id
  

  
  private
    def geocode_location
      address = location + ", " + self.city.city
      geo=Geokit::Geocoders::MultiGeocoder.geocode(address)
      self.lat, self.lng = geo.lat, geo.lng if geo.success
    end
end
