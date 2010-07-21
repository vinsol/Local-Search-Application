require 'spec_helper'

describe OrdersController do
  
  def check_if_owner
    @business = mock_model(Business)
    Business.stub!(:find_by_id).with("id").and_return(@business)
    @businesses = [mock_model(Business), mock_model(Business)]
    @member.stub!(:owned_businesses).and_return(@businesses)
    @businesses.stub!(:include?).and_return(true)
  end
  
  def is_logged_in
     @member = mock_model(Member, {:full_name => "Name"})
     Member.stub!(:find_by_id).with("id").and_return(@member)
  end
  
  describe "new" do
    before(:each) do
      @order = mock_model(Order)
      Order.stub!(:new).and_return(@order)
      is_logged_in
      check_if_owner
    end
    
    it "should allow owners only" do
      @businesses.stub!(:include?).and_return(false)
      session[:member_id] = "id"
      get :new, :business_id => "id"
      response.should redirect_to(business_path("id"))
    end
    
    it "should create a new instance of Order" do
      session[:member_id] = "id"
      get :new, :business_id => "id"
      assigns[:order].should_not be_nil
    end
  end
  
  describe "Create" do
    before(:each) do
      session[:member_id] = "id"
      is_logged_in
      check_if_owner
      @order = mock_model(Order)
      Order.stub!(:new).and_return(@order)
      @order.stub!(:business_id=)
      @order.stub!(:ip_address=)
      @order.stub!(:valid?).and_return(true)
      @order.stub!(:save!).and_return(true)
    end
    
    it "should not render new if order is invalid" do
      @order.stub!(:valid?).and_return(false)
      post :create
      response.should render_template("orders/new")
    end
    
    it "should render new in case of save failure" do
      @order.stub!(:save!).and_return(false)
      post :create
      response.should render_template("orders/new")
    end
    
    it "should redirect to business path in case of successful purchase" do
      @purchase_response = "test"
      @order.stub!(:purchase).and_return(@purchase_response)
      @purchase_response.stub!(:success?).and_return(true)
      post :create, :business_id => "id"
      response.should redirect_to(business_path("id"))
    end
 
    it "should render new in case of purchase failure" do
      @purchase_response = "test"
      @order.stub!(:purchase).and_return(@purchase_response)
      @purchase_response.stub!(:success?).and_return(false)
      @purchase_response.stub!(:message)
      post :create, :business_id => "id"
      response.should render_template("orders/new")
    end
    
    it "should handle SocketError" do
      @order.stub!(:purchase).and_raise(SocketError)
      post :create, :business_id => "id"
      response.should render_template("orders/new.html.erb")
    end
    
    it "should handle ActiveMerchant::ConnectionError" do
      @order.stub!(:purchase).and_raise(ActiveMerchant::ConnectionError)
      post :create, :business_id => "id"
      response.should render_template("orders/new.html.erb")
    end
      
  end
  
  
end
