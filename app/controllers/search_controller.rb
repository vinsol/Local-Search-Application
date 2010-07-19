class SearchController < ApplicationController
  skip_before_filter :authorize, :only => [:index]
  
  def index
    @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                params[:search_type], params[:location])
                                                
    #Redirect back if invalid conditions                                            
    flash_redirect("notice", "Incorrect Details", session[:return_to]) unless @conditions
    
    #Get current location details
    @current_location = Search.set_current_location(params[:location],params[:current_loc])
    @current_location_name = Search.get_location_name(params[:location],params[:current_loc])
    
    #search
    @search_results = Search.get_results(@conditions)
    
    #Redirect back if no results found 
    flash_redirect("notice", "No results found.", session[:return_to]) if @search_results.empty? 
  end

  
end
