class SessionsController < ApplicationController
  skip_before_filter :authorize
  def new
    if is_logged_in
     redirect_to_profile("You are already logged in",'message')
    else
        @title = "Login"
        @member = Member.new
    end
  end

  def delete
      session[:member_id] = nil
      if cookies[:remember_me_id] then cookies.delete :remember_me_id end
      if cookies[:remember_me_code] then cookies.delete :remember_me_code end
      flash[:message] = "Logged Out"
      redirect_to login_path
  end

  def authenticate
    if request.post?
      member = Member.authenticate(params[:member][:email], params[:member][:password])
      if member
        session[:member_id] = member.id
        if params[:member][:remember_me] == "1"
          memberId = (member.id).to_s
          cookies[:remember_me_id] = { :value => memberId, :expires => 14.days.from_now }
          remember_me_time = Time.now
          memberCode = Digest::SHA1.hexdigest( generate_random_string(10) )
          member.update_attribute(:remember_me_token,memberCode)
          member.update_attribute(:remember_me_time, remember_me_time)
          cookies[:remember_me_code] = { :value => memberCode, :expires => 14.days.from_now }
        end
          #flash[:message] = "Welcome #{member.first_name}"
          redirect_to members_path
      else
        flash.now[:notice] = "Invalid login credentials"
        render :action => :new
      end
    end
  end


end
