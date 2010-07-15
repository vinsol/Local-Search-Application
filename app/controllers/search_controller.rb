class SearchController < ApplicationController
  skip_before_filter :authorize, :only => [:index]
  
  def index
    @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                params[:search_type], params[:location])
                                                
    flash_redirect("notice", "Incorrect Details",session[:return_to]) unless @conditions
    @current_location = Search.set_current_location(params[:location],params[:current_loc])
    @current_location_name = params[:location] unless params[:location] == "Location"
    @current_location_name = params[:current_loc].slice!(/^[0-9a-zA-Z\s]+/).capitalize unless params[:current_loc] == "" or params[:current_loc] == nil
    @search_results = Search.get_results(@conditions) 
    flash_redirect("notice", "No results found.", session[:return_to]) if @search_results.empty? 
  end

  
end
