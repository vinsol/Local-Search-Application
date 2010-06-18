class Location < ActiveRecord::Base
  validates_presence_of :location
  belongs_to :city
end
