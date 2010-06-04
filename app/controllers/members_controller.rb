require 'digest/sha1'
class MembersController < ApplicationController
	before_filter :authorize , :except => [:login, :authenticate, :signup, :create, :index, :forgot_password]
	
	def index
		if session[:logged_in] == true
			@member = Member.find_by_id(session[:member_id])
		end		
		@title = "AskMe's Clone"
  end

  def signup
		if session[:logged_in] == true
			flash[:notice] = "You are a registered user"
			redirect_to :action => :index		
		else
			@title = "Signup"
			@member = Member.new
		end		  
	end

  def create
		@member = Member.new(params[:member])
		if @member.save
			flash[:notice] = "Signup Successful"
			session[:member_id] = @member.id
			session[:logged_in]= true
			redirect_to :action => "profile"
		else
			render :action => "signup"
		end
  end

  def login
		if session[:logged_in] == true
			flash[:notice] = "You are already logged in"
			redirect_to :action => :profile
		else
			@title = "Login"
			@member = Member.new
		end
  end
	
	def authenticate
		if request.post?
			member = Member.authenticate(params[:member][:email], params[:member][:password])
			if member
				session[:member_id] = member.id
				session[:logged_in]= true
				if params[:member][:remember_me]
					memberId = (member.id).to_s
					cookies[:remember_me_id] = { :value => memberId, :expires => 14.days.from_now }
					memberCode = Digest::SHA1.hexdigest( member.email )
					cookies[:remember_me_code] = { :value => memberCode, :expires => 14.days.from_now }
						
				end 				
				redirect_to :action => :index
			else
				flash.now[:notice] =  "Invalid login credentials"
				render :action => :login
			end
		end	  
	end
  
	def logout
		session[:member_id] = nil
		session[:logged_in]= false
		if cookies[:remember_me_id] then cookies.delete :remember_me_id end
		if cookies[:remember_me_code] then cookies.delete :remember_me_code end
		flash[:notice] = "Logged Out"
		redirect_to :action => :login
  end

	def profile
		@member = Member.find_by_id(session[:member_id])
		@title = @member.first_name + " " +	@member.last_name
		#render :layout => "profile"
	end

	def edit_profile
		@member = Member.find_by_id(session[:member_id])
		@title = "Edit Profile"
	end
		
	def change_password
		@member = Member.find_by_id(session[:member_id])
		@title = "Change Password"
	end

	def forgot_password
		if request.post?
			member = Member.find_by_email(params[:member][:email])
			if member and member.send_new_password
				flash[:notice] = "A new password has been sent by email."
				redirect_to :action => :login
			else
				flash[:notice] = "Unable to send the password. Try again"
			end
		end
	end

	def save_profile
		@member = Member.find_by_id(session[:member_id])
 		if  @member.update_attributes(params[:member])
			flash[:notice] = "Profile was successfully edited"
			redirect_to :action => :profile
		else
			flash.now[:notice] = "Profile not saved. Please check it again"
			render :action => :edit_profile
		end
	end
	
	def save_password
		@member = Member.find_by_id(session[:member_id])
		@member.password_change = true
 		if  @member.update_attributes(params[:member])
			flash[:notice] = "Password was successfully changed"
			redirect_to :action => :profile
		else
			flash.now[:notice] = "Password not changed. Try again"
			render :action => :change_password
		end
	end
	
	def delete_profile
		Member.find(session[:member_id]).destroy
		session[:member_id] = nil
		session[:logged_in]= false
		if cookies[:remember_me_id] then cookies.delete :remember_me_id end
		if cookies[:remember_me_code] then cookies.delete :remember_me_code end
		flash[:notice] = "Profile Sucessfully Deleted"
		redirect_to :action => :login 
	end

protected	
	def authorize
		if !Member.find_by_id(session[:member_id])
			session[:logged_in]= false
			flash[:notice] = "Please login"
			redirect_to :controller => "members", :action => "login"
		end
	end

	

end
