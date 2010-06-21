class MembersController < ApplicationController
  skip_before_filter :authorize , :only => [:index, :new, :create,:forgot_password]
  before_filter :restrict_if_logged_in, :only => :new
  def index
    @member = Member.find_by_id(session[:member_id])
    @title = "Home"
  end

 
  def show
    @member = Member.find_by_id(session[:member_id])
    @owned_businesses = @member.owned_businesses
    @favorite_businesses = @member.favorite_businesses
    @title = @member.first_name + " " + @member.last_name
  end

  def show_list
     @member = Member.find_by_id(session[:member_id])
     @favorite_businesses = @member.favorite_businesses.paginate :page => params[:page], :per_page => 5
     puts @favorite_businesses
     @title = @member.first_name + " " + @member.last_name
   end
  
  def show_my_businesses
    @member = Member.find_by_id(session[:member_id])
    @owned_businesses = @member.owned_businesses.paginate :page => params[:page], :per_page => 5
  end
  
  def new
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
      flash_redirect("message", "Signup successful. Please login using your credentials.", login_path )
    else
      render :action => :new
    end
  end


  def update
    if @member = Member.find_by_id(session[:member_id]).update_attributes(params[:member])
      flash_redirect("message","Profile was successfully edited", member_path(@member.id) )
    else
      flash_redirect("notice","Profile not saved. Please check it again",edit_member_path(@member.id) )
    end
  end

 
  def destroy
    Member.find(session[:member_id]).destroy
    redirect_to logout_path 
  end
  
  def change_password
    @member = Member.find_by_id(session[:member_id])
      respond_to do |format|
        format.js
      end
  end
  
  def update_password
    @member = Member.find_by_id(session[:member_id])
    @member.password_change = true
    if @member.update_attributes(params[:member])
      flash.now[:message] = "Password Changed"
       respond_to do |format|
         format.js
       end
    else
      flash.now[:notice] = "Password not changed. Try again"
      render :action => :change_password
    end
  end
  
  def forgot_password
    @title = "Forgot Password"
    if request.post?
      if params[:member][:email]
        @member = Member.find_by_email(params[:member][:email])
        if @member and @member.send_new_password
          flash_redirect("message","A new password has been sent by email.",login_path )
        else
          flash[:notice] = "Unable to send the password. Try again"
          render :action => :forgot_password
        end
      end
    end
  end
 
end
