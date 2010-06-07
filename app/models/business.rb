class Business < ActiveRecord::Base
  belongs_to :member
  validates_presence_of :name, :location, :city, :category
  attr_accessible :name, :location, :city, :category
  
end
