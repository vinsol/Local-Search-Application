require 'spec_helper'

describe Location do
  fixtures :cities, :locations
  before(:each) do
    @valid_attributes = { 
                          :id => "47",
                          :city_id => "7",
                         
                          :location => 'Mumbai Central'}
  end

  it "should create a new instance given valid attributes" do
    @location = Location.create!(@valid_attributes)
    
  end
  
  it "should geocode location and save lat/lng for the location before save" do
    @location = Location.create!(@valid_attributes)
    @location.lat.should_not be_nil
    @location.lng.should_not be_nil
  end
  
  it "should require a valid location name" do
    Location.new(:location => " ").should_not be_valid
  end
  
  it "should have an associated city" do
    Location.find(locations(:locations_025)).city.id.should_not == nil
  end
end
