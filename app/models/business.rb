class Business < ActiveRecord::Base
  has_many :business_relations
  has_many :members, :through => :business_relations
  validates_presence_of :name, :location, :city, :category
  attr_accessible :name, :location, :city, :category, :owner
  
end
