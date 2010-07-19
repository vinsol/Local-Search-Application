class AutocompleteController < ApplicationController
  skip_before_filter :authorize, :only => [:city, :location, :sub_category, :names_and_categories]
  before_filter :extract_search_query
  
  def city
    @cities = City.find_cities_by_name(@search_query)
  end

  def location
    @city = City.find_by_name(params[:city])
    @locations = @city.locations.find_by_name(@search_query) unless @city == nil
    @locations = Location.find_by_name(@search_query) if @city == nil
  end

  def sub_category
    @sub_categories = SubCategory.find_by_name(@search_query)
  end

  def names_and_categories
    #sub_categories
    @sub_categories = SubCategory.find_by_name(@search_query)
    #names
    @businesses = Business.find_businesses(params[:city], params[:location], @search_query)
  end

  private
    def extract_search_query
      @search_query = params[:search][SEARCH_REGEX,2]
    end
    
end
