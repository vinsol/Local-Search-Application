require 'spec_helper'

describe BusinessesController do

  describe "Index" do
    before(:each) do
      @businesses = mock_model(Business)
      Business.stub!(:paginate).and_return(@businesses)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :index
      response.should redirect_to(login_path)
    end
    
    it "should find all businesses" do
      Business.should_receive(:paginate).and_return(@businesses)
      get :index
    end
    
    it "should set correct title" do
      get :index
      assigns[:title].should == "Listing Businesses"
    end
    
    it "should render index html template in case of html request" do
      get :index
      response.should render_template("businesses/index.html.erb")
    end
  end
  
  describe "show" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      @business.stub!(:name).and_return("name")
      Business.stub!(:find).and_return(@business)
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
      @business_relations.stub!(:find).and_return(true)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :show
      response.should redirect_to(login_path)
    end
    
    it "should find member from session" do
      Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
      get :show
    end
    
    it "should find business from params" do
      Business.should_receive(:find).with((@business.id).to_s).and_return(@business)
      get :show, :id => @business.id
    end
    
    it "should set correct title" do
      get :show, :id => @business.id
      assigns[:title].should == "Business Details - name"
    end
    
    it "should render show template" do
      get :show, :id => @business.id
      response.should render_template("businesses/show.html.erb")
      assigns[:favorite].should == true
    end
  end
  
  describe "new" do
    before(:each) do
      @cities = mock_model(City)
      City.stub!(:find).and_return(@cities)
      @member = mock_model(Member)
      Member.stub!(:find_by_id).with(@member.id).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:new).and_return(@business)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in members" do
      session[:member_id] = nil
      get :new
      response.should redirect_to(login_path)
    end
    
    it "should set correct title" do
      get :new
      assigns[:title].should == "Add Business"
    end
  end
    

end
