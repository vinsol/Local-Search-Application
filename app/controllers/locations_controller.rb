class LocationsController < ApplicationController

  def index
    search_reg_exp = /(?:([a-zA-Z0-9]*[\s,]+)*)([a-zA-Z0-9]+)$/
    @search_query = params[:search][search_reg_exp,2]
    @city = City.find(:first, :conditions =>['city LIKE ?', "#%{params[:business_city]}"])
    p @city
    @locations = @city.locations.find(:all, 
                      :conditions => ['location LIKE ?',"%#{@search_query}%"])
    
  end  
  
end
