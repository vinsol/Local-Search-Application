require 'spec_helper'

describe SearchController do
  
  describe "Index" do
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :index
      response.should_not redirect_to(login_path)
    end

    it "should call create conditions hash in Search model" do
      Search.should_receive(:create_conditions_hash).with("City","NaC","Type","Location").and_return(@conditions)
      get :index, { :city => "City", :names_and_categories => "NaC", 
                    :search_type => "Type", :location => "Location"}
    end
    
    it "should redirect back if conditions are invalid" do
      session[:return_to] = root_path
      Search.should_receive(:create_conditions_hash).and_return(false)
      get :index, { :city => "City", :names_and_categories => "NaC", 
                    :search_type => "Type", :location => "Location"}
      response.should redirect_to(root_path)
    end
    
    it "should call current location methods in Search model" do
      Search.should_receive(:create_conditions_hash).and_return(@conditons)
      Search.should_receive(:set_current_location).with("Location","Current_loc")
      Search.should_receive(:get_location_name).with("Location","Current_loc")
      get :index, { :city => "City", :names_and_categories => "NaC", 
                    :search_type => "Type", :location => "Location", :current_loc => "Current_loc"}
    end
    
    it "should fetch search results" do
      Search.should_receive(:create_conditions_hash).and_return(@conditons)
      Search.should_receive(:set_current_location).with("Location","Current_loc")
      Search.should_receive(:get_location_name).with("Location","Current_loc")
      Search.should_receive(:get_results).with(@conditions).and_return(@search_results)
      @search_results.stub!(:empty?).and_return(false)
      get :index, { :city => "City", :names_and_categories => "NaC", 
                    :search_type => "Type", :location => "Location", :current_loc => "Current_loc"}
    end
    
    
  end
  
end
