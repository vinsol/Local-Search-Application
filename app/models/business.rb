# == Schema Information
# Schema version: 20100618113518
#
# Table name: businesses
#
#  id                 :integer(4)      not null, primary key
#  name               :string(255)
#  location           :string(255)
#  city               :string(255)
#  category           :string(255)
#  status             :string(255)     default("unverified")
#  created_at         :datetime
#  updated_at         :datetime
#  owner              :string(255)
#  contact_name       :string(255)
#  contact_phone      :string(255)
#  contact_email      :string(255)
#  contact_website    :string(255)
#  contact_address    :string(255)
#  map                :string(255)
#  description        :text
#  opening_time       :datetime
#  closing_time       :datetime
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  sub_category       :string(255)
#

class Business < ActiveRecord::Base  
  
  #RELATIONS
  has_many :business_relations, :dependent => :destroy
  has_many :members, :through => :business_relations, :source => :member
  has_many :orders

  has_one :business_owner, :through => :business_relations, :source => :member, :conditions => ["business_relations.status = ?", RELATION[:OWNED]]
  has_attached_file :photo, :styles => {:thumb => THUMB, :medium => MEDIUM }
  
  acts_as_mappable
  
  #has_and_belongs_to_many :categories
  has_and_belongs_to_many :sub_categories
  
  #CALLBACKS
  before_validation_on_create :geocode_address, :unless => lambda{|a| a.contact_address.blank?}
  before_save :geocode_address, :unless => lambda{|a| a.contact_address.blank?}
  
  #after_create :build_business_relation  
  
  #VALIDATIONS
  validates_attachment_size :photo, :less_than => 1.megabytes, 
                                    :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], 
                                    :if => Proc.new { |imports| !imports.photo_file_name.blank? }

  validates_presence_of :name, :location, :city,:contact_name
  validates_presence_of :contact_phone, :contact_address
  
  validates_format_of :contact_website,
      :message => "must be a valid url",
      :with => URL
      
  validates_format_of :contact_phone, 
      :message => "must be a 10 digit valid telephone number.",
      :with => PHONE
  validate :validate_timings
  validates_format_of :contact_email, 
      :with => EMAIL , 
      :unless => lambda{|a| a.contact_email.blank?}
      
  #ATTRIBUTES
  attr_accessible :name, :location, :city, :owner, :contact_name, :contact_email, :photo, :sub_category_name, :is_premium, :business_details, :title, :send_sms
  attr_accessible :contact_phone, :contact_website, :contact_address, :description, :opening_time, :closing_time
  attr_accessor :distance
  cattr_reader :per_page
  @@per_page = 5
  
  define_index do
      indexes :name, :sortable => true
      indexes location, :as => :location
      indexes city, :as => :city
      indexes sub_categories.sub_category, :as => :sub_category
      has is_premium
      set_property :enable_star => 1
      set_property :min_infix_len => 3 
  end
  
  #Class Methods
  def self.find_businesses(city, location, name)
    if city != 'City Name' && location != 'Location'
      businesses = find_by_all(city, location, name) 
    elsif city != 'City Name'
      businesses = find_by_city_and_name(city, name) 
    elsif location != "Location"
      businesses = find_by_location_and_name(location, name)
    else
      businesses = find_by_name(name) 
    end
    return businesses
  end
  
  def self.find_by_all(city, location, name)
    Business.find(:all, :conditions => [ 'name LIKE ? and city LIKE ? and location LIKE ?',
                                                 "%#{name}%","%#{city}", "%#{location}" ])
  end
  
  def self.find_by_city_and_name(city, name)
    Business.find(:all, :conditions => [ 'name LIKE ? and city LIKE ?',
                                                 "%#{name}%","%#{city}"])
  end
  
  def self.find_by_location_and_name(location, name)
    Business.find(:all, :conditions => [ 'name LIKE ? and location LIKE ?',
                                                 "%#{name}%", "%#{location}" ])
  end
  
  def self.find_by_name(name)
    Business.find(:all, :conditions => [ 'name LIKE ?',"%#{name}%"])
  end
  
  #Instance Methods
  def get_map
    unless lat == nil or lng == nil
      map = GoogleMap::Map.new
      map.center = GoogleMap::Point.new(lat,lng)
      map.zoom = 15
      map.markers << GoogleMap::Marker.new(:map => map, :lat => lat, :lng => lng, :html => name)
      return map
    end
  end
   
  #Virtual Attributes
  def sub_category_name
    self.sub_categories.collect { |sub_category| sub_category.sub_category + ","}
  end
  
  def sub_category_name=(string)
    string.split(",").collect { |sub_category| 
      @sub_cat = SubCategory.find_by_sub_category(sub_category.strip)
      if self.sub_categories.find(:all, :conditions => ["sub_category_id = ?",@sub_cat.id]).empty?
        self.sub_categories << @sub_cat
      end 
    }
  end
 
  def title
    self.name + ", " + self.location + ", " + self.city
  end
  
  def business_details
    self.name + " - " + self.contact_phone + " - " + self.contact_address + ", " + self.location + ", " + self.city
  end
  
  def send_sms(number)
    url_details = URI.escape(business_details, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
    url = SMS_API + url_details + "&recipient=" + number
    Net::HTTP.get_print URI.parse(url)
  end
    
  protected
  
  def validate_timings
     errors.add_to_base "Opening Time must be less than Closing Time" if self.opening_time > self.closing_time
  end
    
  private
  
 
  def geocode_address
    geo=Geokit::Geocoders::MultiGeocoder.geocode(contact_address + "," + self.location + "," + self.city)
    errors.add(:contact_address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat, geo.lng if geo.success
  end
  
end
