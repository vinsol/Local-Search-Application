require 'spec_helper'

describe SearchController do
  before(:each) do
    @valid_params = { :city => "Delhi", :location => "Patel Nagar", :names_and_categories => "Restaurant", :search_type => "category"}
  end
  it "should allow non logged in users" do
    session[:member_id] = nil
    get :index, @valid_params
    response.should_not redirect_to(login_path)
  end
  
  it "should redirect back of conditions hash is empty" do
    @conditions = {}
    Search.stub!(:create_conditions_hash).and_return(@conditions)
    session[:return_to] = root_path
    get :index, @valid_params
    response.should redirect_to(root_path)
  end
  
    
  
 
end
