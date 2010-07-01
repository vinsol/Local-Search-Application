require 'spec_helper'

describe SessionsController do
 
  
  describe "new" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:new).and_return(@member)
      Member.stub!(:find_by_id).with("1").and_return(@member)
      session[:member_id] = nil
    end
    
    
    it "should set page title to login" do
      get :new
      assigns["title"].should == "Login"
    end
    
    it "should render new login form" do
      get :new
      response.should render_template('sessions/new.html.erb')
    end
    
    it "should create a new instance of Member class" do
      Member.should_receive(:new).and_return(@member)
      get :new
    end
    
    it "should not allow logged in users" do
      session[:member_id] = "1"
      get :new
      flash[:message].should == "You are already logged in"
      response.should redirect_to(member_path(@member.id))
    end
    
  end
  
  describe "delete" do
    before(:each) do
      session[:member_id] = "1"
    end
    
    it "should empty the session" do
      get :delete
      session[:member_id].should == nil
    end
    
    it "should set the correct flash message" do
      get :delete
      flash[:message].should == "Logged out"
    end
    
    it "should redirect to login path" do
      get :delete
      response.should redirect_to(login_path)
    end
  end
  
  
  describe "authenticate" do
    
    describe "with valid params" do
      before(:each) do
        @member = mock_model(Member, :update_attributes => true)
        Member.stub!(:authenticate).with("valid_emai", "valid_password",nil).and_return(true)
      end
    
      it "should authenticate the member the member" do
        Member.should_receive(:authenticate).with("valid_email","valid_password",nil).and_return(true)
        post :authenticate, :member => {:email => "valid_email", :password => "valid_password"}
      end
    
      it "should set session" do
        Member.should_receive(:authenticate).with("valid_email","valid_password",nil).and_return(true)
        post :authenticate, :member => {:email => "valid_email", :password => "valid_password"}
        session[:member_id].should_not == nil
      end
    
      it "should set remember me cookie when member has selected remember me" do
        Member.should_receive(:authenticate).with("valid_email","valid_password",nil).and_return(@member)
        @member.stub!(:remember_me_token).and_return("random_token")
        @member.stub!(:remember_me_time).and_return("Current Time")
        post :authenticate, :member => {:email => "valid_email", :password => "valid_password", :remember_me => "1"}
        cookies[:remember_me_id].should_not == nil
        cookies[:remember_me_code].should_not == nil
      end
        
      it "should redirect to member profile" do
        
        Member.should_receive(:authenticate).with("valid_email","valid_password",nil).and_return(true)
        post :authenticate, :member => {:email => "valid_email", :password => "valid_password"}
        response.should redirect_to(members_path)
      end
    end
    
    
    describe "with invalid attributes" do
      before(:each) do
        @member = mock_model(Member)
        Member.stub!(:authenticate).with("invalid_emai", "invalid_password",nil).and_return(nil)
      end
    
      it "should render new template" do
        Member.should_receive(:authenticate).with("invalid_email","invalid_password",nil).and_return(nil)
        post :authenticate, :member => {:email => "invalid_email", :password => "invalid_password"}
        response.should render_template("sessions/new.html.erb")
      end
    end
  end
  

end
