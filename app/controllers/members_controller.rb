class MembersController < ApplicationController
  before_filter :authorize , :except => [:new, :create,:forgot_password]
  def index
    if session[:logged_in] == true
      @member = Member.find_by_id(session[:member_id])
    end
    @title = "AskMe's Clone"
  end

 
  def show
    @member = Member.find_by_id(session[:member_id])
    @businesses = @member.businesses
    @title = @member.first_name + " " + @member.last_name

  end

  
  def new
    if session[:logged_in] == true
      flash[:notice] = "You are a registered user"
      redirect_to members_path
    else
      @title = "Signup"
      @member = Member.new
    end
  end

  
  def edit
    @member = Member.find_by_id(session[:member_id])
    @title = "Edit Profile"
    
  end

 
  def create
    @member = Member.new(params[:member])
    if @member.save
      session[:member_id] = @member.id
      session[:logged_in]= true
      flash[:notice] = 'Member was successfully created.'
      redirect_to member_path(session[:member_id])
    else
      redirect_to new_member_path
    end
  end


  def update
    @member = Member.find_by_id(session[:member_id])
    if @member.update_attributes(params[:member])
      flash[:notice] = "Profile was successfully edited"
      redirect_to member_path(session[:member_id])
    else
      flash.now[:notice] = "Profile not saved. Please check it again"
      redirect_to edit_member_path(session[:member_id])
    end
  end

 
  def destroy
    Member.find(session[:member_id]).destroy
    session[:member_id] = nil
    session[:logged_in]= false
    if cookies[:remember_me_id] then cookies.delete :remember_me_id end
    if cookies[:remember_me_code] then cookies.delete :remember_me_code end
    flash[:notice] = "Profile Sucessfully Deleted"
    redirect_to login_path
    
  end
  
  def change_password
    if request.get?
      @member = Member.find_by_id(session[:member_id])
      @title = "Change Password"
    elsif request.post?
      @member = Member.find_by_id(session[:member_id])
      @member.password_change = true
      if @member.update_attributes(params[:member])
        flash[:notice] = "Password was successfully changed"
        redirect_to :action => :profile
      else
        flash.now[:notice] = "Password not changed. Try again"
        render :action => :change_password
      end
    end    
  end
  
  def forgot_password
    if request.post?
      member = Member.find_by_email(params[:member][:email])
      p member.email
      if member and member.send_new_password
        p "=====>>>>>"
        flash[:notice] = "A new password has been sent by email."
        redirect_to login_path
      else
        flash[:notice] = "Unable to send the password. Try again"
        render :action => :forgot_password
      end
    end
  end

  
  
 
end
