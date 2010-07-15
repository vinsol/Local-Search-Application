require 'spec_helper'

describe OrdersController do

  
  describe "New Order" do
    before(:each) do
      session[:member_id] = "2"
      @member = mock_model(Member)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.stub!(:find).with("valid_business_id").and_return(@business)
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
      
    end

    it "should create a new instance of Order model for owners" do
      @business_relations.stub!(:find).and_return(true)
      @order = mock_model(Order)
      Order.should_receive(:new).and_return(@order)
      Business.should_receive(:find).and_return(@business)
      get :new
    end
    
    it "should not allow non owners" do
      @business_relations.stub!(:find).and_return(false)
      Business.should_receive(:find).and_return(@business)
      get :new, :business_id => "2"
      response.should redirect_to(business_path("2"))
    end
    
  end
  
  describe "Create Order" do
    before(:each) do
      session[:member_id] = "2"
      @member = mock_model(Member)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @business = mock_model(Business)
      Business.should_receive(:find).and_return(@business)
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
      @business_relations.stub!(:find).and_return(true)     
    end
    
    describe "for successful order save" do
      before(:each) do
        @order = mock_model(Order, {:save! => true, :valid? => true })
        Order.should_receive(:new).with("valid_data").and_return(@order)
        @order.should_receive(:business_id=)
        @order.should_receive(:ip_address=)
      end
      
      it "should create a new instance of Order from the params" do
        @order.should_receive(:purchase).and_return(@response)
        @response.should_receive(:success?).and_return(true)
        post :create, {:order => "valid_data", :business_id => "1"}
        flash[:message].should == "Transaction Successful. Your business will now appear in premium listings."
        response.should redirect_to(business_path("1"))
      end
     
      it "should render new template in case of purchase failure" do
        @order.should_receive(:purchase).and_return(@purchase)
        @purchase.stub!(:message).and_return("Test Message")
        @purchase.should_receive(:success?).and_return(false)
        
        post :create, {:order => "valid_data", :business_id => "1"}
        response.should render_template("orders/new.html.erb")
      end
      
      it "should handle socket error" do
        @order.should_receive(:purchase).and_raise(SocketError)
        post :create, {:order => "valid_data", :business_id => "1"}
        response.should render_template("orders/new.html.erb")
      end
      
      it "should handle ActiveMerchant::ConnectionError" do
        @order.should_receive(:purchase).and_raise(ActiveMerchant::ConnectionError)
        post :create, {:order => "valid_data", :business_id => "1"}
        response.should render_template("orders/new.html.erb")
      end
        
    end
    
    describe "For unsuccessful order save" do
      before(:each) do
        @order = mock_model(Order, {:save! => false, :valid? => true })
        Order.should_receive(:new).with("valid_data").and_return(@order)
        @order.should_receive(:business_id=)
        @order.should_receive(:ip_address=)
      end
      
      it "should render new action" do
        post :create, {:order => "valid_data", :business_id => "1"}
        response.should render_template("orders/new.html.erb")
      end
      
    end
    
    describe "For invalid data" do
      before(:each) do
         @order = mock_model(Order, {:save! => false, :valid? => false })
          Order.should_receive(:new).with("valid_data").and_return(@order)
          @order.should_receive(:business_id=)
          @order.should_receive(:ip_address=)
        end

      it "should render new action" do
        post :create, {:order => "valid_data", :business_id => "1"}
        response.should render_template("orders/new.html.erb")
      end

    end
        
  end
end
