require 'spec_helper'

describe AutocompleteController do

  it "should extract last word from search query" do
    get :city, :search => "test, query"
    assigns[:search_query].should == "query"
  end
  
  
  it "should query City model and render proper template" do
    City.should_receive(:find).with(:all, {:conditions=>["city LIKE ?", "%test%"]})
    get :city, :search => "test"
    response.should render_template("autocomplete/city")
  end
  
  describe "location" do
    it "should fetch all locations with given conditions if a city in not found" do
      City.should_receive(:find).with(:first, {:conditions=>["city LIKE ?", "%test%"]}).and_return(nil)
      Location.should_receive(:find)
      get :location, {:search => "test", :city => "test"}
    end
    
    it "should fetch locations for a city if a city is found" do
      @city = mock_model(City, {:city => "test"})
      City.should_receive(:find).with(:first, {:conditions=>["city LIKE ?", "%test%"]}).and_return(@city)
      @locations = mock_model(Location)
      @city.should_receive(:locations).and_return(@locations)
      @locations.should_receive(:find_by_name)
     
      get :location, {:search => "test", :city => "test"}
    end
  end
  
  describe "sub_category" do
    it "should fetch subcategories from Subcategory model" do
      SubCategory.should_receive(:find).with(:all, {:conditions=>["sub_category LIKE ?", "%test%"]})
      get :sub_category, :search => "test"
    end
  end
  
  describe "names_and_categories" do
    before(:each) do
      @businesses = mock_model(Business)
      @businesses.stub!(:empty?).and_return(false)
    end
    
    it "should find intersection of city, name and location when name and location are mentioned" do
      Business.should_receive(:find).with(:all, {:conditions=>["name LIKE ? and city LIKE ? and location LIKE ?", "%test%", "%test", "%test"]}).and_return(@businesses)
      get :names_and_categories, {:search => "test", :city => "test", :location => "test"}
    end
    
    it "should find intersection of city and name when location is not mentioned" do
      Business.should_receive(:find).with(:all, {:conditions=>["name LIKE ? and city LIKE ?", "%test%", "%test"]}).and_return(@businesses)
      get :names_and_categories, {:search => "test", :city => "test", :location => "Location"}
    end
    
    it "should find intersection of location and name when city is not mentioned" do
      Business.should_receive(:find).with(:all, {:conditions=>["name LIKE ? and location LIKE ?", "%test%", "%test"]}).and_return(@businesses)
      get :names_and_categories, {:search => "test", :city => "City Name", :location => "test"}
    end
    
    it "should find businesses by name when city and location are not mentioned" do
      Business.should_receive(:find).with(:all, {:conditions=>["name LIKE ?", "%test%"]}).and_return(@businesses)
      get :names_and_categories, {:search => "test", :city => "City Name", :location => "Location"}
    end
    
   
  end
end
