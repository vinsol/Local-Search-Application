class Business < ActiveRecord::Base  
  has_many :business_relations
  has_many :members, :through => :business_relations, :source => :member
  has_attached_file :photo, :styles => {:thumb => "160x190>", :medium => "640x640>" }
  validates_attachment_size :photo, :less_than => 1.megabytes  
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']

  validates_presence_of :name, :location, :city, :category, :contact_name 
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
  attr_accessible :name, :location, :city, :category, :owner, :contact_name, :contact_email, :photo
  attr_accessible :contact_phone, :contact_website, :contact_address, :description, :opening_time, :closing_time
  
  cattr_reader :per_page
  @@per_page = 5
  
  protected
  def validate_timings
     errors.add_to_base "Opening Time must be less than Closing Time" if self.opening_time >= self.closing_time
  end
  
  
end
