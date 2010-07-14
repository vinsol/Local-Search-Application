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
    
    if @conditions == {}
      return false
    else
      return @conditions
    end
    
  end
    
    
  def self.search(conditions, current_lat=0, current_lng=0)
    @results = Business.search :conditions => conditions, :include => :sub_categories, :order => "is_premium DESC"
    unless @results.empty?
      @results.each do |result|
       first_loc = Geokit::LatLng.new(result.lat,result.lng)
       second_loc = Geokit::LatLng.new(current_lat,current_lng)
        result.distance = first_loc.distance_to(second_loc)
      end
    end
    return @results
  end
  
 
      
    
end
