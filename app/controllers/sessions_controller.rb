class SessionsController < ApplicationController
  
  def new
      if session[:logged_in] == true
        flash[:message] = "You are already logged in"
        redirect_to member_path(session[:member_id])
      else
      @title = "Login"
      @member = Member.new
      end
  end

  def delete
      session[:member_id] = nil
      session[:logged_in]= false
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
          session[:logged_in]= true
          if params[:member][:remember_me]
            memberId = (member.id).to_s
            cookies[:remember_me_id] = { :value => memberId, :expires => 14.days.from_now }
            memberCode = Digest::SHA1.hexdigest( member.email )
            cookies[:remember_me_code] = { :value => memberCode, :expires => 14.days.from_now }
          end
          flash[:message] = "Welcome #{member.first_name}"
          redirect_to members_path
        else
        flash.now[:notice] = "Invalid login credentials"
        render :action => :new
        end
    end
  end

end
