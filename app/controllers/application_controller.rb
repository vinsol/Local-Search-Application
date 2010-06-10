# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_remember_me
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
    def authorize
      if session[:logged_in] != true
        flash[:message] = "Please login"
        redirect_to login_path
      end
    end
    
    def check_remember_me
      unless session[:logged_in] 
        if cookies[:remember_me_id] 
          member = Member.find_by_id(cookies[:remember_me_id])
          if member and cookies[:remember_me_code] == member.remember_me_token
            session[:member_id] = member.id
            session[:logged_in] = true
            redirect_to member_path(member.id)
          end
        end
      end
    end
    
    def redirect_to_profile(msg,type)
      if type == 'notice'
        flash[:notice] = msg
      elsif type == 'message'
          flash[:message] = msg
      end
      redirect_to member_path(session[:member_id])
    end

end

