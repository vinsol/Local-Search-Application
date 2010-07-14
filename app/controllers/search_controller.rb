class SearchController < ApplicationController
  skip_before_filter :authorize, :only => [:index]
  
  def index
    @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                  params[:search_type], params[:location])
    @current_location = Location.find(:first, :conditions => ['location = ?',params[:location]]) unless params[:location] == nil
    if @current_location == nil and params[:current_loc] !=nil
      @current_location = Geokit::Geocoders::MultiGeocoder.geocode(params[:current_loc])  
      @current_loc_name = @current_location.district
    end
    #replace ip with remote.request_ip
    @current_location = Geokit::Geocoders::MultiGeocoder.geocode(request.remote_ip) if @current_location == nil
    @lat = @current_location.lat
    @lng = @current_location.lng
    if @current_loc_name == nil and @current_location.lat != nil and @current_location.lng != nil
      @current_loc_name = @current_location.location if @current_loc_name == nil and @current_location != nil
    end
    unless @conditions
      flash[:notice] = "Incorrect Details"
      redirect_to session[:return_to]
      
    else
      p @current_location
      @search_results = Search.search(@conditions,@lat,@lng)
      @search_results.sort! { |a,b| a.distance <=> b.distance }
       
      if @search_results.empty?
        
        @conditions = Search.create_conditions_hash(params[:city], params[:names_and_categories], 
                                                      params[:search_type], nil)
        @search_results = Search.search(@conditions,@lat,@lng) 
        @search_results.sort! { |a,b| a.distance <=> b.distance }
        if @search_results.empty?
          flash[:notice] = "No results found."
          redirect_to session[:return_to]
        else
         
          @search_results
        end
      end
    end
          
  end

  def show_on_map
    @result_id = params[:id]
    @map = GoogleMap::Map.new
    @map.center = GoogleMap::Point.new(params[:lat], params[:lng])
    @map.zoom = 15
    @map.markers << GoogleMap::Marker.new(  :map => @map,
                                            :lat => params[:lat],
                                            :lng => params[:lng],
                                            :html => params[:name])
    
    respond_to do |format|
      format.js
    end
                                            
  end
end
