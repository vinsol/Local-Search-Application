class MembersController < ApplicationController
  skip_before_filter :authorize , :only => [:index, :new, :create, :forgot_password]
  before_filter :restrict_if_logged_in, :only => :new
  
  def index
    @title = "Home"
    @cities = City.all
    @categories = Category.find(:all, :include => :sub_categories) 
  end
 
  def show
    @title = @member.full_name
  end

  def show_list
    @favorite_businesses = @member.favorite_businesses.paginate :page => params[:page], :per_page => 5
    @title = @member.full_name
   end
  
  def show_my_businesses
    @owned_businesses = @member.owned_businesses.paginate :page => params[:page], :per_page => 5
    @title = @member.full_name
  end

  def new
    @title = "Signup"
    @member = Member.new
  end

  def edit
    @title = "Edit Profile"
  end

  def create
    @member = Member.new(params[:member])
    if @member.save
      flash_redirect("message", "Signup successful. Please login using your credentials.", login_path )
    else
      render :action => :new
    end
  end


  def update
    if @member.update_attributes(params[:member])
      flash_redirect("message","Profile was successfully edited", member_path(@member.id) )
    else
      flash_redirect("notice","Profile not saved. Please check it again",edit_member_path(@member.id) )
    end
  end
  
  def update_password
    @member.password_change = true
    if @member.update_attributes(params[:member])
      flash.now[:message] = "Password Changed"
       respond_to do |format|
         format.js
       end
    else
      flash_render("notice","Password not changed. Try again","update_password" )
    end
  end
 
  def destroy
    @member.destroy
    redirect_to logout_path 
  end
  
  def forgot_password
    @title = "Forgot Password"
    if request.post? and params[:member][:email]
      @member = Member.find_by_email(params[:member][:email])
      if @member
        if @member.send_new_password
          flash_redirect("message","A new password has been sent by email.",login_path )
        else
          flash_render("notice", "Unable to send the password. Try again","forgot_password")
        end
      else
        flash_render("notice", "Invalid email", "forgot_password")
      end
    end
  end
 
end
