# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require 'digest/sha1'
class ApplicationController < ActionController::Base
	filter_parameter_logging :password	
	before_filter :check_remember_me	
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
	
#protected
	def check_remember_me
		if cookies[:remember_me_id]		
		member = Member.find_by_id(cookies[:remember_me_id])
			if member		
				code = Digest::SHA1.hexdigest(member.email)
				remember_me_code = cookies[:remember_me_code]
				if code == remember_me_code
					session[:member_id] = member.id
					session[:logged_in] = true				
				end		  
			end
		end
	end
	

end
