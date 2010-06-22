require 'spec_helper'

describe City do
  fixtures :cities, :locations
  before(:each) do
    @valid_attributes = { :city => "Delhi"}
  end

  it "should create a new instance given valid attributes" do
    City.create!(@valid_attributes)
  end
  
  it "should require a valid city name" do
    City.new(:city => " ").should_not be_valid
  end
  
  it "should have valid locations" do
    @city = City.find(cities(:delhi))
    @city.locations.should_not be_empty
  end
end
