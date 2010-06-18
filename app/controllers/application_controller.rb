# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_remember_me
  before_filter :authorize
  before_filter :jumpback
  
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
    def authorize
      unless is_logged_in
        flash[:message] = "Please login"
        redirect_to login_path
      end
    end
    
    def check_remember_me
      unless is_logged_in
        if cookies[:remember_me_id] 
          member = Member.find_by_id(cookies[:remember_me_id])
          if member.remember_me_time >= 14.days.ago and member and cookies[:remember_me_code] == member.remember_me_token
            session[:member_id] = member.id
            redirect_to root_path
          end
        end
      end
    end
    
    def generate_random_string(len)
         #generate a salt consisting of strings and digits
         chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
         random_string = ""
         1.upto(len) { |i| random_string << chars[rand(chars.size-1)] }
         return random_string
    end
    
    def redirect_to_profile(msg,type)
      if type == 'notice'
        flash[:notice] = msg
      elsif type == 'message'
          flash[:message] = msg
      end
      redirect_to member_path(session[:member_id])
    end

    def is_logged_in
      if @member = Member.find_by_id(session[:member_id])
        @logged_in = true
        return true
      else
        @logged_in = false
        return false
      end
    end
    
    
    def jumpback
      session[:jumpback] = session[:jumpcurrent]
      session[:jumpcurrent] = request.request_uri
    end
      
    def check_admin
      if Member.find_by_id(session[:member_id]).is_admin == true
        return true
      else
        redirect_to root_path
      end
    end
      
      
    def rescue_action_in_public(exception)
      case exception
        when ::ActionController::RedirectBackError
          jumpto = session[:jumpback] || {:controller => "/my_overview"}
          redirect_to jumpto
        else
          super
        end
    end
      
end

