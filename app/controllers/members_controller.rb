class MembersController < ApplicationController
  before_filter :authorize , :except => [:index, :new, :create,:forgot_password]
  
  def index
    @member = Member.find_by_id(session[:member_id])
    @title = "Home"
  end

 
  def show
    @member = Member.find_by_id(session[:member_id])
    @owned_businesses = @member.owned_businesses
    @favorite_businesses = @member.favorite_businessess
    @title = @member.first_name + " " + @member.last_name
  end

  def show_list
     @member = Member.find_by_id(session[:member_id])
     @favorite_businesses = @member.favorite_businesses
     puts @favorite_businesses
     @title = @member.first_name + " " + @member.last_name
   end
  
  
  def new
    redirect_to_profile("Logged in users can not register","notice") unless session[:logged_in] != true
    @title = "Signup"
    @member = Member.new
  end

  
  def edit
    @member = Member.find_by_id(session[:member_id])
    @title = "Edit Profile"
  end

 
  def create
    @member = Member.new(params[:member])
    if @member.save and @member.signup_notification
      session[:member_id] = @member.id
      redirect_to_profile('Member was successfully created.',"message")
    else
      render :action => :new
    end
  end


  def update
    if Member.find_by_id(session[:member_id]).update_attributes(params[:member])
      redirect_to_profile("Profile was successfully edited","message") 
    else
      flash.now[:notice] = "Profile not saved. Please check it again"
      redirect_to edit_member_path(session[:member_id])
    end
  end

 
  def destroy
    Member.find(session[:member_id]).destroy
    redirect_to logout_path 
  end
  
  def change_password
    @member = Member.find_by_id(session[:member_id])
    if request.get?
      @title = "Change Password"
    elsif request.post?
      @member.password_change = true
      if @member.update_attributes(params[:member])
       redirect_to_profile("Password was successfully changed","message")
      else
        flash.now[:notice] = "Password not changed. Try again"
        render :action => :change_password
      end
    end    
  end
  
  def forgot_password
    @title = "Forgot Password"
    if request.post?
      if params[:member][:email]
        @member = Member.find_by_email(params[:member][:email])
        if @member and @member.send_new_password
          flash[:message] = "A new password has been sent by email."
          redirect_to login_path
        else
          flash[:notice] = "Unable to send the password. Try again"
          render :action => :forgot_password
        end
      end
    end
  end
 
end
