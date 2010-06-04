class AdminController < ApplicationController
	before_filter :authorize , :except => [:login, :authenticate]
	
	def index
		@users = User.all		
		@members = Member.all
		@title = "Admin Module"
  end

  def login
		if $logged_in == "true"
			flash[:notice] = "You are already logged in"
			redirect_to :action => :index
		else
			@title = "Login"
			@user = User.new
		end  
	end
	
	def authenticate
		if request.post?
			user = User.authenticate(params[:user][:email], params[:user][:password])
			if user
				session[:user_id] = user.id
				$logged_in = "true"
				redirect_to :action => :index
			else
				flash.now[:notice] =  "Invalid login credentials"
				render :action => :login
			end
		end
	end
		
  def logout
		session[:user_id] = nil
		$logged_in = "false"
		flash[:notice] = "Logged Out"
		redirect_to :action => :login
  end

  def create_user
		@title = "Create User"
		@user = User.new
  end

  def save_user
		@user = User.new(params[:user])
		if @user.save
			flash[:notice] = "User successfull created"
			session[:user_id] = @user.id
			$logged_in = "true"
			redirect_to :action => "index"
		else
			render :action => "create_user"
		end
 end
	
	def change_password
		@member = User.find_by_id(session[:user_id])
		@title = "Change Password"
	end
	
	def save_password
		@user = User.find_by_id(session[:user_id])
		@user.password_change = true
 		if  @user.update_attributes(params[:user])
			flash[:notice] = "Password was successfully changed"
			redirect_to :action => :index
		else
			flash.now[:notice] = "Password not changed. Try again"
			render :action => :change_password
		end
	end
	
  
  def delete_user
  end

	def authorize
		unless User.find_by_id(session[:user_id])
		$logged_in = "false"
		flash[:notice] = "Please login"
		redirect_to :controller => "admin", :action => "login"
		end
	end
end
