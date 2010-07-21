require 'spec_helper'

describe BusinessesController do
  
  def is_logged_in
    @member = mock_model(Member, {:full_name => "Name"})
    Member.stub!(:find_by_id).with("id").and_return(@member)
  end
  
  def find_business_by_id
    @business = mock_model(Business, {:name => "Name"})
    Business.stub!(:find_by_id).with("id").and_return(@business)
  end
  
  describe "Index" do
    before(:each) do
      @businesses = [mock_model(Business), mock_model(Business)]
      Business.stub!(:paginate).and_return(@businesses)
    end
    
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :index
      response.should_not redirect_to(login_path)
    end
    
    it "should set title" do
      get :index
      assigns[:title].should_not be_nil
    end
    
    it "should find the businesses" do
      get :index
      assigns[:businesses].should_not be_empty
    end
  end

  describe "Show" do
    before(:each) do
      find_business_by_id
      @map = mock_model(GoogleMap::Map)
      @business.stub!(:get_map).and_return(@map)
    end
    
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :show, :id => "id"
      response.should_not redirect_to(login_path)
    end
    
    it "should set title" do
      get :show, :id => "id"
      assigns[:title].should_not be_nil
    end
    
    it "should fetch the map" do
      get :show, :id => "id"
      assigns[:map].should_not be_nil
    end
  end
  
  describe "new" do
    before(:each) do
      is_logged_in
      @business = mock_model(Business)
      Business.stub!(:new).and_return(@business)
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :new
      response.should redirect_to(login_path)
    end
    
    it "should set the title" do
      session[:member_id] = "id"
      get :new
      assigns[:title].should_not be_nil
    end
    
    it "should create a new instance of Business" do
      session[:member_id] = "id"
      get :new
      assigns[:business].should_not be_nil
    end
  end
  
  describe "Edit" do
    before(:each) do
      is_logged_in
      find_business_by_id
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :edit, :id => "id"
      response.should redirect_to(login_path)
    end
    
    it "should set the title" do
      session[:member_id] = "id"
      get :edit, :id => "id"
      assigns[:title].should_not be_nil
    end
    
    it "should find business from id" do
      session[:member_id] = "id"
      get :edit, :id => "id"
      assigns[:business].should_not be_nil
    end
  end
  
  describe "Send to phone" do
    before(:each) do
      #is_logged_in
      find_business_by_id
      @business.stub!(:send_sms)
    end
    
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :send_to_phone, :id => "id"
      response.should_not redirect_to(login_path)
    end
    
    it "should render correct template" do
      get :send_to_phone, :id => "id"
      response.should render_template("businesses/send_to_phone.js.rjs")
    end
  end
  
  describe "Create" do
    before(:each) do
      is_logged_in
      @business = mock_model(Business, {:save => true})
      Business.stub!(:new).and_return(@business)
      @business_relation = mock_model(BusinessRelation, {:build => true})
      @business.stub!(:business_relations).and_return(@business_relation)
      @business.stub!(:owner=)
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      post :create
      response.should redirect_to(login_path)
    end
    
    it "should set correct flash message on save" do
      session[:member_id] = "id"
      post :create
      flash[:message].should == "Business was successfully added"
    end
    
    it "should redirect to businesses_path in case of successful save" do
      session[:member_id] = "id"
      post :create
      response.should redirect_to(businesses_path)
    end
    
    it "should render new form on unsuccessful save" do
      @business.stub!(:save).and_return(false)
      session[:member_id] = "id"
      post :create
      response.should render_template("businesses/new.html.erb")
    end 
  end

  describe "Update" do
    before(:each) do
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @businesses = [mock_model(Business), mock_model(Business)]
      @member.stub!(:owned_businesses).and_return(@businesses)
      @businesses.stub!(:include?).and_return(true)
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      put :update, :id => "id"
      response.should redirect_to(login_path)
    end
    
    it "should not allow non owners" do
      @businesses.stub!(:include?).and_return(false)
      put :update, :id => "id" 
      flash[:notice] == "Nice try"
      response.should redirect_to(member_path(@member.id))
    end
    
    it "should render edit action on update failure" do
      @business.stub!(:update_attributes).and_return(false)
      put :update, :id => "id" 
      response.should render_template("businesses/edit.html.erb")
    end
    
    it "should set flash message on successful update" do
      @business.stub!(:update_attributes).and_return(true)
      put :update, :id => "id"
      flash[:message].should == "Business was successfully added"
      response.should redirect_to(business_path("id"))
    end
  end
  
  describe "Destroy" do
    before(:each) do
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @businesses = [mock_model(Business), mock_model(Business)]
      @member.stub!(:owned_businesses).and_return(@businesses)
      @businesses.stub!(:include?).and_return(true)
    end
    
    it "should not allow non owners" do
      @businesses.stub!(:include?).and_return(false)
      delete :destroy, :id => "id"
      response.should redirect_to(member_path(@member.id))
    end
    
    it "should set flash and redirect to member path on successful destroy" do
      @business.stub!(:destroy).and_return(true)
      delete :destroy, :id => "id"
      flash[:message].should == "Business was successfully deleted"
      response.should redirect_to(member_path(@member.id))
    end
    
    it "should redirect to business path in case of failed destruction" do
      @business.stub!(:destroy).and_return(false)
      delete :destroy, :id => "id"
      response.should redirect_to(business_path(@business.id))
    end
  end
    
  describe "Add Favorite" do
    before(:each) do
      session[:return_to] = root_path
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :add_favorite, :id => "id"
      response.should redirect_to(login_path)
    end
    
    it "should not allow adding same business twice" do
      @business_relations.stub!(:find).and_return(true)
      get :add_favorite, :id => "id"
      response.should redirect_to(root_path)
    end
    
    it "should render correct template on successful create" do
      @business_relations.stub!(:find).and_return(false)
      @business_relations.stub!(:create).and_return(true)
      get :add_favorite, :id => "id"
      response.should render_template("businesses/add_favorite.js.rjs")
    end
    
    it "should set correct flash notice on failed create" do
      @business_relations.stub!(:find).and_return(false)
      @business_relations.stub!(:create).and_return(false)
      get :add_favorite, :id => "id"
      flash[:notice].should == "Unable to add business to your list. Try again."
      response.should redirect_to(root_path)
    end
  end
  
  describe "Remove Favorite" do
    before(:each) do
      session[:return_to] = root_path
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :remove_favorite, :id => "id"
      response.should redirect_to(login_path)
    end
    
    it "should allow removing favorites only" do
      @business_relations.stub!(:find).and_return(false)
      get :remove_favorite, :id => "id"
      response.should redirect_to(root_path)
    end
    
    it "should render correct template on destroy" do
      BusinessRelation.stub!(:destroy).and_return(true)
      @business_relations.stub!(:find).and_return(true)
      get :remove_favorite, :id => "id"
      response.should render_template("businesses/remove_favorite.js.rjs")
    end
    
    it "should set correct flash notice on failed create" do
      @business_relations.stub!(:find).and_return(true)
      BusinessRelation.stub!(:destroy).and_return(false)
      get :remove_favorite, :id => "id"
      flash[:notice].should == "Unable to remove from list. Please try again."
      response.should redirect_to(root_path)
    end
  end
end
