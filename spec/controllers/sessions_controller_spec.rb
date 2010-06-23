require 'spec_helper'

describe SessionsController do
  integrate_views
  fixtures :members
  
  describe "new" do
    
    it "should set page title to login" do
      get :new
      assigns["title"].should == "Login"
    end
    
    it "should render new login form" do
      get :new
      response.should render_template('sessions/new.html.erb')
    end
    
    it "should create a new instance of Member class" do
      get :new
      @member.should be_nil
    end
    
    it "should not allow logged in users" do
      Member.stub!(:authenticate).and_return(session[:member_id] = 1)
      get :new
      response.should redirect_to(member_path(session[:member_id]))
    end
    
  end
  
  describe "delete" do
    
    before(:each) do
      Member.stub!(:authenticate).and_return(session[:member_id] = 1)
    end
    
   
    it "should not allow members who have not logged in" do
      session[:member_id] = nil
      get :delete
      response.should redirect_to(login_path)
    end
    
    it "should flash a message to members who have not logged in" do
      session[:member_id] = nil
      get :delete
      flash[:message].should == "Please Login"
    end
    
    it "should clear the session" do
      get :delete
      session[:member_id].should == nil
    end
    
    it "should flash a message" do
      get :delete
      flash[:message].should == "Logged out"
    end
    
    it "should redirect to login path" do
      get :delete
      response.should redirect_to(login_path)
    end
  end
  
  describe "authenticate" do
    
    it "should call authenticate method" do
      Member.should_receive(:authenticate).with("jagira@gmail.com","google")
      post :authenticate, :member => {:email => "jagira@gmail.com", :password => "google"}
    end
    
    it "should set session for valid members" do
      post :authenticate, :member => { :email => "jagira@gmail.com", :password => "google"}
      session[:member_id].should == 1
    end
    
    it "should set remember_me id if member has checked remember me" do
      post :authenticate, :member => { :email => "jagira@gmail.com", :password => "google", :remember_me => "1"}
      cookies[:remember_me_id].should == "1"
    end
    
    it "should set remember me code if member has checked remember me" do
      post :authenticate, :member => { :email => "jagira@gmail.com", :password => "google", :remember_me => "1"}
      cookies[:remember_me_code].should_not be_nil
    end
    
    it "should redirect to members path on successful authentication" do
      post :authenticate, :member => { :email => "jagira@gmail.com", :password => "google"}
      response.should redirect_to(members_path)
    end
    
    it "should render login page on unsuccessful authentication" do
      post :authenticate, :member => { :email => "jagira@gmail.com", :password => "invalid"}
      response.should render_template('sessions/new.html.erb')
    end
    
  end
  
  

end
