# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_remember_me
  before_filter :authorize
  before_filter :store_return_path, :except => :flash_redirect
  
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  protected
    def authorize
      flash_redirect("message", "Please Login", login_path) unless is_logged_in
    end
    
    def check_remember_me
      unless is_logged_in
        if cookies[:remember_me_id] 
          @member = Member.find_by_id(cookies[:remember_me_id])
          if @member.remember_me_time >= 14.days.ago and member and cookies[:remember_me_code] == @member.remember_me_token
            session[:member_id] = @member.id
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
    

    def is_logged_in
      if @member = Member.find_by_id(session[:member_id])
        @logged_in = true
        return true
      else
        @logged_in = false
        return false
      end
    end
    
    def restrict_if_logged_in
      if @member = Member.find_by_id(session[:member_id])
        @logged_in = true
        flash_redirect("message","You are already logged in", member_path(@member.id))
      end
    end
    
    def flash_redirect(type,content,destination)
      flash[:"#{type}"] = content
      redirect_to destination
    end
    
      
    def check_admin
      if Member.find_by_id(session[:member_id]).is_admin == true
        return true
      else
        redirect_to root_path
      end
    end
    
    def store_return_path
      session[:return_to] = request.referrer
    end
      
    
end

