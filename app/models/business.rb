class Business < ActiveRecord::Base
  has_many :business_relations
  has_many :members, :through => :business_relations
  has_one :business_details
  accepts_nested_attributes_for :business_details, :allow_destroy => true
  
  validates_presence_of :name, :location, :city, :category
  attr_accessible :name, :location, :city, :category, :owner
  
end
