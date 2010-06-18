class Admin::MembersController < ApplicationController
   before_filter :check_admin
      active_scaffold :member	do |config|
        config.columns = [:id, :first_name, :last_name, :email]
      end
    
    
  
end
