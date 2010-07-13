class Search < ActiveRecord::Base
  attr_accessor :create_conditions_hash
  def create_conditions_hash(city=nil, names_and_categories=nil, n_a_c_type=nil, location=nil)
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
    
    
  def search(conditions)
    @results = Business.search :conditions => conditions, :include => :sub_categories, :order => "is_premium DESC"
    unless @results.empty?
      @results.each do |result|
        p"=====>>>>>>>>>>>>>>>"
        @result.distance = find_distance(result.lat, result.lng, @current_lat, @current_lng)
        
        p @result.distance
      end
    end
    return @results
  end
  
  def find_distance(lat_1,lng_1,lat_2,lng_2)
    distance = Math.sqrt(((110*(lat_1-lat2))**2)-((28*(lng_1-lng_2))**2))
  end
      
    
end
