# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :check_remember_me
  before_filter :authorize
  before_filter :store_return_path, :except => :flash_redirect
  
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
   filter_parameter_logging :password, :salt, :hashed_password
  protected
    def authorize
      flash_redirect("message", "Please Login", login_path) unless is_logged_in
    end
    
    def check_remember_me
      unless is_logged_in
        if cookies[:remember_me_id] 
          @member = Member.find_by_id(cookies[:remember_me_id])
          if @member and @member.remember_me_time > 14.days.ago and cookies[:remember_me_code] == @member.remember_me_token
            session[:member_id] = @member.id
            redirect_to root_path
          end
        end
      end
    end
  
    def is_logged_in
      unless session[:member_id] == nil
        if @member = Member.find_by_id(session[:member_id])
          @logged_in = true
          return true
        else
          @logged_in = false
          return false
        end
      end
    end
    
    def restrict_if_logged_in
      if @member
        @logged_in = true
        flash_redirect("message","You are already logged in", session[:return_to])
      end
    end
    
    def flash_redirect(type,content,destination)
      flash["#{type}".to_sym] = content
      redirect_to destination
     
    end
    
    def flash_render(type,content,action)
      flash.now["#{type}".to_sym] = content
      render :action => action
    end
    
    #Checks whether the person is owner or not.
    def is_owner(business)
      @member.owned_businesses.include?(business)
    end
    
    #checks whether the person has added the business as favorite.
     def is_favorite(business)
      @business_relation = business.business_relations.find(:first, 
                                                            :conditions => ["member_id = ? AND status = ?",
                                                                  @member.id,RELATION[:FAVORITE]])
      @business_relation ? true : false
    end
    
   
    
    def check_admin
      if @member.is_admin
        true
      else
        flash_redirect("notice","You are not expected here.", root_path)
      end
    end
    
    def store_return_path
      session[:return_to] = request.referrer
    end
    
    
end

