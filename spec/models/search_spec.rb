require 'spec_helper'

describe Search do
 
  describe "search" do
    fixtures :locations, :businesses
    before(:each) do
      
    end
    
   it "should find results on submission of valid params" do
      
      @conditions = Search.create_conditions_hash("Delhi","Restaurant", "category","Patel Nagar")
      @current_location = Search.set_current_location(nil,"Patel Nagar")
      @results = Search.get_results(@conditions)
      @results.should_not be_empty
    end
    
    it "should remove location from condition and find in entire city in case of empty results" do
      @conditions = Search.create_conditions_hash("Delhi","Restaurant", "category","Rajiv Chowk")
      @current_location = Search.set_current_location(nil,"Patel Nagar")
      @results = Search.get_results(@conditions)
      @results.should include(businesses(:businesses_002))
    end
  end
end
