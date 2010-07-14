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
  has_many :business_relations
  has_many :members, :through => :business_relations, :source => :member
  has_attached_file :photo, :styles => {:thumb => THUMB, :medium => MEDIUM }
  acts_as_mappable
  #has_and_belongs_to_many :categories
  has_and_belongs_to_many :sub_categories
  
  #CALLBACKS
  before_validation_on_create :geocode_address, :unless => lambda{|a| a.contact_address.blank?}
  before_save :geocode_address, :unless => lambda{|a| a.contact_address.blank?}
    
  
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
  attr_accessible :name, :location, :city, :owner, :contact_name, :contact_email, :photo, :sub_category_name, :is_premium
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
      set_property :delta => true
      
  end
  
  def sub_category_name
    self.sub_categories.collect { |sub_category| sub_category.sub_category + ","}
  end
  
  def sub_category_name=(string)
    string.split(",").collect { |sub_category| 
      @relation = SubCategory.find_by_sub_category(sub_category.strip)
         if self.sub_categories.find(:all, :conditions => ["sub_category_id = ?",@relation.id]).empty?
           self.sub_categories << @relation
         end
      }
  end
 
  
  protected
  
  def validate_timings
     errors.add_to_base "Opening Time must be less than Closing Time" if self.opening_time > self.closing_time
  end
  
  private
  def geocode_address
    geo=Geokit::Geocoders::MultiGeocoder.geocode(contact_address + "," + self.location + "," + self.city)
    errors.add(:contact_address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end
  
end
