class SearchController < ApplicationController
  skip_before_filter :authorize, :only => [:index]
  
  def index
    @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                  params[:search_type], params[:location])
    @current_location = Location.find(:first, :conditions => ['location = ?',params[:location]])
    @current_lat = @current_location.lat
    @current_lng = @current_location.lng
    unless @conditions
      flash[:notice] = "Incorrect Details"
      redirect_to root_path
    else
      @search_results = Search.search(@conditions,@current_lat,@current_lng) 
      if @search_results.empty?
        @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                      params[:search_type], nil)
        @search_results = Search.search(@conditions,@current_lat,@current_lng) 
        if @search_results.empty?
          flash[:notice] = "No results found."
          redirect_to root_path
        else
          @search_results
        end
      end
    end
          
  end

end
