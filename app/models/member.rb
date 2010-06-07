require 'digest/sha1'
class Member < ActiveRecord::Base
  has_many :businesses
  validates_presence_of :email, :first_name, :last_name, :phone_number, :address
  validates_uniqueness_of :email
  validates_format_of :phone_number, 
      :message => "must be a 10 digit valid telephone number.",
      :with => /^[\(\)0-9\- \+\.]{10}$/
  validates_format_of :email, :with => /^([^\s]+)((?:[-a-z0-9]\.)[a-z]{2,})$/i
 
      
      
  validates_presence_of :password, :if => :password_present
  validates_confirmation_of :password
  attr_accessor :password_confirmation, :password_change, :remember_me
  attr_accessible :email, :first_name, :last_name, :password, :password_confirmation, :remember_me
  attr_accessible :phone_number, :address

  after_save :signup_notification

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
