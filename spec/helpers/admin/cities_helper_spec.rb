require 'spec_helper'

describe Admin::CitiesHelper do
  fixtures :cities, :locations
  
  it "should return locations if record has any locations" do
    record = cities(:cities_004)
    helper.locations_column(record).should_not be_empty
  end
  
end