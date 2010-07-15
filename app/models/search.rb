class Search < ActiveRecord::Base
  require 'geokit'
  acts_as_mappable
  attr_accessor :create_conditions_hash
  
  def self.create_conditions_hash(city=nil, names_and_categories=nil, n_a_c_type=nil, location=nil)
    @conditions = {}
    @conditions[:city] = city unless ["", nil, "City Name"].include?(city)
    @conditions[:location] = location unless ["", nil, "Location"].include?(location)
    unless ["", nil, "Product/Name"].include?(names_and_categories)
      @conditions[:name] = names_and_categories if n_a_c_type == 'name' 
      @conditions[:sub_category] = names_and_categories if n_a_c_type == 'category'
    end
    return false if @conditions.empty?
    return @conditions 
  end
    
  def self.get_results(conditions)
    results = search(conditions)
    if results.empty?
      conditions.delete(:location)
      results = search(conditions)
    end
    return results
  end
    
  def self.search(conditions)
    @results = Business.search :conditions => conditions, :include => :sub_categories, :order => "is_premium DESC"
    unless @results.empty?
      current_lat = @current_location.lat ||= 0
      current_lng = @current_location.lng ||= 0
      @results.each do |result|
        first_loc = Geokit::LatLng.new(result.lat,result.lng)
        second_loc = Geokit::LatLng.new(current_lat,current_lng)
        result.distance = first_loc.distance_to(second_loc)
      end
    end
    @results.sort! { |a,b| a.distance <=> b.distance }
    return @results
  end
  
 
  def self.set_current_location(location="",current_location="")
    @current_location = Geokit::Geocoders::MultiGeocoder.geocode(current_location) if current_location != "" 
    @current_location = Location.find(:first, 
                                      :conditions => ['location = ?',location]) if @current_location == nil
    @current_location = Location.new if @current_location == nil
    return @current_location
  end
end
