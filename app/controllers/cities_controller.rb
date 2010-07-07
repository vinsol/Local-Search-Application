class CitiesController < ApplicationController
skip_before_filter :authorize, :only => [:index]
  def index
    @search_query = params[:search][SEARCH_REGEX,2]
    @cities = City.find(:all, :conditions => ['city LIKE ?', "%#{@search_query}%"])
  end  
  
end
