class AutocompleteController < ApplicationController
  skip_before_filter :authorize, :only => [:city, :location, :sub_category, :name]

  
  def city
    @search_query = extract_search_query(params[:search])
    @cities = City.find(:all, :conditions => ['city LIKE ?', "%#{@search_query}%"])
  end

  def location
    @city = City.find(:first, :conditions => ['city LIKE ?', "%#{params[:city]}"])
    @search_query = extract_search_query(params[:search])
    @locations = @city.locations.find(:all, 
                                :conditions => ['location LIKE ?',"%#{@search_query}%"]) unless @city == nil
    @locations = Location.find( :all, 
                                :conditions => ['location LIKE ?',"%#{@search_query}%"]) if @city == nil
  end

  def sub_category
    @search_query = extract_search_query(params[:search])
    @sub_categories = SubCategory.find(:all, :conditions => ['sub_category LIKE ?', "%#{@search_query}%"])
  end

  def names_and_categories
    @search_query = extract_search_query(params[:search])
    @sub_categories = SubCategory.find(:all, :conditions => ['sub_category LIKE ?', "%#{@search_query}%"])
    
    #for names
    if params[:city] != 'City Name' && params[:location] != 'Location'
      @businesses = Business.find(:all, :conditions => 
                                      [ 'name LIKE ? and city LIKE ? and location LIKE ?',
                                        "%#{@search_query}%","%#{params[:city]}", "%#{params[:location]}" ])
    elsif params[:city] != 'City Name'
      @businesses = Business.find(:all, :conditions => 
                                  ['name LIKE ? and city LIKE ? ',"%#{@search_query}%","%#{params[:city]}" ])
    elsif params[:location] != 'Location'
      @businesses = Business.find(:all, :conditions => 
                              ['name LIKE ? and location LIKE ?',"%#{@search_query}%","%#{params[:location]}"])
    else
      @businesses = Business.find(:all, :conditions => ['name LIKE ?',"%#{@search_query}%"])
    end
  end

  private
    def extract_search_query(query)
      @search_query = query[SEARCH_REGEX,2]
    end
    
end
