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
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:new).and_return(@business)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in members" do
      session[:member_id] = nil
      get :new
      response.should redirect_to(login_path)
    end
    
    it "should find member using session" do
      Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
      get :new
    end
    
    it "should set correct title" do
      get :new
      assigns[:title].should == "Add Business"
    end
    
    it "should return all cities" do
      City.should_receive(:find).with(:all).and_return(@cities)
      get :new
    end
    
    it "should create a new instance of business class" do
      Business.should_receive(:new).and_return(@business)
      get :new
    end
    
    it "should render new business template" do
      get :new
      response.should render_template('businesses/new.html.erb')
    end
    
  end
    
  describe "get locations" do
    before(:each) do
      session[:member_id] = 1
      @city = mock_model(City)
      City.stub!(:find_by_city).with('valid_city').and_return(@city)
      @locations = mock_model(Location)
      @city.stub!(:locations).and_return(@locations)
    end
    
    it "should allow only xhr requests" do
      get :get_locations
      flash[:error].should == "Invalid Page"
      response.should redirect_to(root_path)
    end
    
    it "should find the city from params" do
      City.should_receive(:find_by_city).with('valid_city').and_return(@city)
      xhr :get, :get_locations, :business_city => "valid_city"
    end
    
    it "should return list of locations for a particular city" do
      @city.should_receive(:locations).and_return(@locations)
      xhr :get, :get_locations, :business_city => "valid_city"
    end
  end

  describe "get sub_categories" do
    before(:each) do
      session[:member_id] = 1
      @category = mock_model(Category)
      Category.stub!(:find_by_category).with('valid_category').and_return(@category)
      @sub_categories = mock_model(SubCategory)
      @category.stub!(:sub_categories).and_return(@sub_categories)
    end
    
    it "should allow only xhr requests" do
      get :get_sub_categories
      flash[:error].should == "Invalid page"
      response.should redirect_to(root_path)
    end
    
    it "should find the category from params" do
      Category.should_receive(:find_by_category).with('valid_category').and_return(@category)
      xhr :get, :get_sub_categories, :business_category => "valid_category"
    end
    
    it "should return list of sub categories for a valid category" do
      @category.should_receive(:sub_categories).and_return(@sub_categories)
      xhr :get, :get_sub_categories, :business_category => "valid_category"
    end
  end
  
  describe "edit" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:find_by_id).with("1").and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:find).with('valid_business_id').and_return(@business)
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
      @business_relations.stub!(:find).and_return(true)
      session[:member_id] = "1"
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :edit
      response.should redirect_to(login_path)
    end
    
    it "should set correct title" do
      get :edit, :id => "valid_business_id"
      assigns[:title].should == "Edit Business"
    end
    
    it "should find member from session" do
      Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
      get :edit, :id => "valid_business_id"
    end
    
    it "should find business from params" do
      Business.should_receive(:find).with("valid_business_id").and_return(@business)
      get :edit, :id => "valid_business_id"
    end
    
    it "should render edit template" do
      get :edit, :id => "valid_business_id"
      response.should render_template("businesses/edit.html.erb")
    end
  end
  
  describe "create" do
    describe "with valid attributes" do
      
      before(:each) do
        session[:member_id] = 1
        @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
        Member.stub!(:find_by_id).with(1).and_return(@member)
        @business = mock_model(Business, :save => true)
        Business.stub!(:new).with("valid_attr").and_return(@business)
        Business.stub!(:new).and_return(@business)
        @business.stub!(:owner=).and_return("Jigar Patel")
        @business_relation = mock_model(BusinessRelation, :create => true)
      end
      
      it "should not allow non logged in users" do
        session[:member_id] = nil
        post :create
        response.should redirect_to(login_path)
      end
      
      it "should find member from session" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        post :create, :business => "valid_attr"
      end
      
      it "should create a instance of Business with valid attr" do
        Business.should_receive(:new).with("valid_attr").and_return(@business)
        post :create, :business => "valid_attr"
      end
      
      it "should set the business owner" do
        @business.should_receive(:owner=).and_return("Jigar Patel")
        post :create, :business => "valid_atrr"
      end
      
      it "should save the business with valid attr" do
        @business.should_receive(:save).and_return(true)
        post :create, :business => "valid_attr"
      end
      
      it "should create a  business relation" do
        BusinessRelation.should_receive(:create).and_return(true)
        post :create, :business => "valid_attr"
      end
      
      it "should set correct flash message" do
        post :create, :business => "valid_attr"
        flash[:message].should == "Business was successfully added"
      end
      
      it "should redirect to businesses path" do
        post :create, :business => "valid_attr"
        response.should redirect_to(businesses_path)
      end
    end
    
    describe "with invalid attributes" do
      
     before(:each) do
        session[:member_id] = 1
        @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
        Member.stub!(:find_by_id).with(1).and_return(@member)
        @business = mock_model(Business, :save => false)
        Business.stub!(:new).with("invalid_attr").and_return(@business)
        Business.stub!(:new).and_return(@business)
        @business.stub!(:owner=).and_return("Jigar Patel")
        @business.stub!(:destroy).and_return(true)
        
      end
      
      it"should not save the business with invalid attr" do
        @business.should_receive(:save).and_return(false)
        post :create, :business => "invalid_attr"
      end
      
      it "should destroy the business" do
        @business.should_receive(:destroy).and_return(true)
        post :create, :business => "invalid_attr"
      end
      
      it "should render new business template" do
        post :create, :business => "invalid_attr"
        response.should  render_template("businesses/new.html.erb")
      end
    end
  end
  
  describe "update" do
    
    before(:each) do
      session[:member_id] = 1
      @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business, :update_attributes => true)
      Business.stub!(:find).with('valid_business_id').and_return(@business)
    end
    
    describe "when member is owner" do
      before(:each) do
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(true)
      end
        
      it "should find member from session" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        put :update, :id => "valid_business_id"
      end
    
      it "should update business with valid attributes" do
        @business.should_receive(:update_attributes).and_return(true)
        put :update, :id => "valid_business_id"
      end
      
      it "should set the correct flash message" do
        put :update, :id => "valid_business_id"
        flash[:message].should == "Business was successfully added"
      end
    
      it "should redirect to business path" do
        put :update, :id => "valid_business_id"
        response.should redirect_to(business_path("valid_business_id"))
      end
    end
      
    describe "with invalid attributes" do
      before(:each) do
        @business = mock_model(Business, :update_attributes => false)
        Business.stub!(:find).with('valid_business_id').and_return(@business)
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(true)
        
      end
        
      it "should not update the business" do
        @business.should_receive(:update_attributes).and_return(false)
        put :update, :id => "valid_business_id"
      end
        
      it "should render edit template" do
        put :update, :id => "valid_business_id"
        response.should render_template("businesses/edit.html.erb")
      end
    end
    
    describe "when member is not owner" do
      before(:each) do
        @business = mock_model(Business)
        Business.stub!(:find).with('valid_business_id').and_return(@business)
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(false)
      end
      
      it "should redirect to member profile" do
        put :update, :id => "valid_business_id"
        response.should redirect_to(member_path(@member.id))
      end
    end  
  end
  
  describe "destroy" do
    before(:each) do
      session[:member_id] = 1
      @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:find).with("valid_business_id").and_return(@business)
    end
    
    describe "when member is owner" do
      before(:each) do
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(true)
      end
      
      describe "and business is destroyed" do
        before(:each) do
          @business.stub!(:destroy).and_return(true)
        end
        
        it "should find business from params" do
          Business.should_receive(:find).with("valid_business_id").and_return(@business)
          post :destroy, { :method => :delete, :id => "valid_business_id"}
        end
        
        it "should set correct flash message" do
          post :destroy, { :method => :delete, :id => "valid_business_id"}
          flash[:message].should == "Business was successfully deleted"
        end
        
        it "should redirect to member profile" do
          post :destroy, { :method => :delete, :id => "valid_business_id"}
          response.should redirect_to(member_path(1))
        end
      end
      
      describe "and business is not destroyed" do
        before(:each) do
          @business.stub!(:destroy).and_return(false)
        end
        
        it "should redirect to business show page" do
          post :destroy, { :method => :delete, :id => "valid_business_id"}
          response.should redirect_to(business_path(@business.id))
        end
      end
    end
    
    describe "member is not owner" do
      before(:each) do
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(false)
      end
      
      it "should set correct flash notice" do
        post :destroy, { :method => :delete, :id => "valid_business_id"}
        flash[:notice].should == "You can delete your own business"
      end
      
      it "should redirect to member profile" do
        post :destroy, { :method => :delete, :id => "valid_business_id"}
        response.should redirect_to(member_path(1))
      end
    end
  end
  
  describe "add favorite" do
    before(:each) do
      session[:member_id] = 1
      @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:find_by_id).with("valid_business_id").and_return(@business)
    end
    
    describe "when business is already in favorite list" do
      before(:each) do
        session[:return_to] = root_path
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(true)
      end
      
      it "should find business from params" do
        Business.should_receive(:find_by_id).with("valid_business_id").and_return(@business)
        get :add_favorite, :id => "valid_business_id"
      end
      
      it "should set the correct flash notice" do
        get :add_favorite, :id => "valid_business_id"
        flash[:notice].should == "Business already in your list"
      end
      
      it "should redirect to back" do
        get :add_favorite, :id => "valid_business_id"
        response.should redirect_to(session[:return_to])
      end
    end
    
    describe "when business is not in the favorite list" do
      before(:each) do
        session[:return_to] = root_path
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(false)
      end
      
      it "should render add favorite rjs when business is added" do
        BusinessRelation.stub!(:create).and_return(true)
        get :add_favorite, :id => "valid_business_id"
        response.should render_template("businesses/add_favorite.js.rjs")
      end
      
      it "should set flash notice when business is not added" do
        BusinessRelation.stub!(:create).and_return(false)
        get :add_favorite, :id => "valid_business_id"
        flash[:notice].should == "Unable to add business to your list. Try again."
      end
    end
  end
  
  describe "remove favorite" do
    before(:each) do
      session[:member_id] = 1
      session[:return_to] = root_path
      @member = mock_model(Member, {:first_name => "Jigar", :last_name => "Patel"})
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:find_by_id).with("valid_business_id").and_return(@business)
    end
    
    describe "when business is not in your list" do
      before(:each) do
        session[:return_to] = root_path
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(false)
      end    
        
      it "should find business from params" do
        Business.should_receive(:find_by_id).with("valid_business_id").and_return(@business)
        post :remove_favorite, {:method => :delete, :id => "valid_business_id"}
      end
      
      it "should set correct flash notice" do
        post :remove_favorite, {:method => :delete, :id => "valid_business_id"}
        flash[:notice].should == "Business not in your list"
      end
      
      it "should redirect to back" do
        post :remove_favorite, {:method => :delete, :id => "valid_business_id"}
        response.should redirect_to(session[:return_to])
      end
    end
    
    describe "when business is not in your list" do
      before(:each) do
        session[:return_to] = root_path
        @business_relations = mock_model(BusinessRelation)
        @business.stub!(:business_relations).and_return(@business_relations)
        @business_relations.stub!(:find).and_return(true)
      end
      
      it "should render remove favorite rjs template on successful deletion from list" do
        BusinessRelation.stub!(:destroy).and_return(true)
        post :remove_favorite, {:method => :delete, :id => "valid_business_id"}
        response.should render_template("businesses/remove_favorite.js.rjs")
      end
      
      it "should set a flash notice and redirect to back when business is not deleted" do
        BusinessRelation.stub!(:destroy).and_return(false)
        post :remove_favorite, {:method => :delete, :id => "valid_business_id"}
        flash[:notice].should == "Unable to remove from list. Please try again."
        response.should redirect_to(session[:return_to])
      end
    end
  end
end