# == Schema Information
# Schema version: 20100618113518
#
# Table name: members
#
#  id                 :integer(4)      not null, primary key
#  email              :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  salt               :string(255)
#  hashed_password    :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  phone_number       :string(255)
#  address            :string(255)
#  remember_me_token  :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer(4)
#  photo_updated_at   :datetime
#  remember_me_time   :datetime
#  is_admin           :boolean(1)
#

class Member < ActiveRecord::Base
  has_attached_file :photo, :styles => {:thumb => "160x190>" }
  validates_attachment_size :photo, :less_than => 1.megabytes, 
                                    :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif'], 
                                            :if => Proc.new { |imports| !imports.photo_file_name.blank? }
  has_many :businesses, :through => :business_relations, :source => :business
  has_many :business_relations
  has_many :owned_businesses, :through => :business_relations, :source => :business, :conditions => ["business_relations.status = ?", RELATION[:OWNED]]
  has_many :favorite_businesses, :through => :business_relations, :source => :business, :conditions => ["business_relations.status = ?", RELATION[:FAVORITE]]
  
  
  validates_presence_of :email, :first_name, :last_name, :phone_number, :address
  validates_uniqueness_of :email
  validates_format_of :phone_number, 
      :message => "must be a 10 digit valid telephone number.",
      :with => PHONE
  validates_format_of :email, :with => EMAIL , :unless => lambda{|a| a.email.blank?}
  validates_presence_of :password, :if => :password_present
  validates_confirmation_of :password
  
  attr_accessor :password_confirmation, :password_change, :remember_me
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :remember_me
  attr_accessible :phone_number, :address, :remember_me_token, :photo
  
  
  
  def password
    @password
  end

  def password=(pass)
    @password = pass
    return if pass.blank?
    create_new_salt(15)
    self.hashed_password = Member.encrypted_password(self.password, self.salt)
  end

  def self.authenticate(email,password)
    member = Member.find_by_email(email)
    if member
      expected_password = encrypted_password(password, member.salt)
      if expected_password != member.hashed_password
        member = nil
      end
    end
    member
  end

  def signup_notification
    Notifications.deliver_send_notification_mail(self.first_name, self.last_name, self.email)
  end

  def send_new_password
    new_password = create_new_salt(7)
    self.password = self.password_confirmation = new_password
    self.save
    Notifications.deliver_forgot_password(self.email, self.first_name, self.last_name, new_password)
  end

  private

  def create_new_salt(len)
     #generate a salt consisting of strings and digits
     chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
     random_string = ""
     1.upto(len) { |i| random_string << chars[rand(chars.size-1)] }
     self.salt = random_string
  end

  
  def self.encrypted_password(password,salt)
    string_to_hash = password + "jagira" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def password_present
    password_change == true || hashed_password.blank?
  end
  

  
end
