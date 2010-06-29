class Admin::MembersController < ApplicationController
   before_filter :check_admin
    active_scaffold :member	do |config|
      config.columns = [ :first_name, :last_name, :email, :is_admin]
    end
    
end
