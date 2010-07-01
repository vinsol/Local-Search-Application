class SessionsController < ApplicationController
  skip_before_filter :authorize, :only => [:new, :authenticate]
  before_filter :restrict_if_logged_in, :only => :new
  
  def new
    @title = "Login"
    @member = Member.new
  end

  def delete
      session[:member_id] = nil
      if cookies[:remember_me_id] then cookies.delete :remember_me_id end
      if cookies[:remember_me_code] then cookies.delete :remember_me_code end
      flash_redirect("message","Logged out", login_path)  
  end

  def authenticate
    if request.post? and @member = Member.authenticate(params[:member][:email],   params[:member][:password], params[:remember_me])
      session[:member_id] = @member.id
      if params[:member][:remember_me] == "1"
        cookies[:remember_me_id] = { :value => @member.id.to_s, :expires => 14.days.from_now }
        cookies[:remember_me_code] = {  :value => @member.remember_me_token, 
                                        :expires => 14.days.from_now }
      end
        #flash[:message] = "Welcome #{member.first_name}"
        redirect_to members_path
    else
      flash.now[:notice] = "Invalid login credentials"
      render :action => :new
    end
  end


end
