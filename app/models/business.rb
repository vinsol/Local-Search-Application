class Business < ActiveRecord::Base
  has_many :business_relations
  has_many :members, :through => :business_relations

  validates_presence_of :name, :location, :city, :category, :contact_name, :contact_email
  validates_presence_of :contact_phone, :contact_website, :contact_address, :description, :opening_time, :closing_time
  
  validates_format_of :contact_phone, 
      :message => "must be a 10 digit valid telephone number.",
      :with => PHONE
  
  validates_format_of :contact_email, 
      :with => EMAIL , 
      :unless => lambda{|a| a.contact_email.blank?}
  attr_accessible :name, :location, :city, :category, :owner, :contact_name, :contact_email
  attr_accessible :contact_phone, :contact_website, :contact_address, :description, :opening_time, :closing_time
  
  cattr_reader :per_page
  @@per_page = 5
  
  
end
