class User < ActiveRecord::Base
	validates_presence_of :email, :full_name, :employee_id, :role	
	validates_uniqueness_of :email, :employee_id
	validates_presence_of :password, :if => :password_present
	validates_confirmation_of :password, :if => :password_present
	attr_accessor :password_confirmation, :password_change
	attr_accessible :email, :full_name, :employee_id, :password, :password_confirmation, :role
	
	def password
		@password
	end
	
	def password=(pass)
		@password = pass
		return if pass.blank?
		create_new_salt
		self.hashed_password = User.encrypted_password(self.password, self.salt)
	end

	def self.authenticate(email,password)
		user = User.find_by_email(email)
		if user
			expected_password = encrypted_password(password, user.salt)
			if expected_password != user.hashed_password
				user = nil
			end
		end
		user
	end

private

	def create_new_salt
  	#generate a salt consisting of strings and digits
  	chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  	random_string = ""
  	1.upto(15) { |i| random_string << chars[rand(chars.size-1)] }
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
