class Admin::CitiesController < ApplicationController
  before_filter :check_admin
  active_scaffold :cities	do |config|
    
     
  end
end
