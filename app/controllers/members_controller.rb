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
    @owned_businesses = @member.owned_businesses
    @favorite_businesses = @member.favorite_businesses
    @title = @member.first_name + " " + @member.last_name

  end

  
  def new
    if session[:logged_in] == true
      flash[:notice] = "Logged in users cannot signup"
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
      flash[:message] = 'Member was successfully created.'
      redirect_to member_path(session[:member_id])
    else
      render :action => :new
    end
  end


  def update
    @member = Member.find_by_id(session[:member_id])
    if @member.update_attributes(params[:member])
      flash[:message] = "Profile was successfully edited"
      redirect_to member_path(session[:member_id])
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
    if request.get?
      @member = Member.find_by_id(session[:member_id])
      @title = "Change Password"
    elsif request.post?
      @member = Member.find_by_id(session[:member_id])
      @member.password_change = true
      if @member.update_attributes(params[:member])
        flash[:message] = "Password was successfully changed"
        redirect_to :action => :profile
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
        member = Member.find_by_email(params[:member][:email])
        if member and member.send_new_password
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
