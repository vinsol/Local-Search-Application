require 'spec_helper'

describe Location do
  fixtures :cities, :locations
  before(:each) do
    @valid_attributes = { :location => "rajiv chowk", :city_id => "1"}
  end

  it "should create a new instance given valid attributes" do
    Location.create!(@valid_attributes)
  end
  
  it "should require a valid location name" do
    Location.new(:location => " ").should_not be_valid
  end
  
  it "should have an associated city" do
    Location.find(locations(:rajiv_chowk)).city.id.should_not == nil
  end
end
