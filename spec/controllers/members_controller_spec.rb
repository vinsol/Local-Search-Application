require 'spec_helper'

describe MembersController do

  describe "Index" do
    
    it "should allow non logged in users" do
      get :index
      response.should be_success
    end
    
    it "should set title as home" do
      get :index
      assigns["title"].should == "Home"
    end
    
    it "should render index template" do
      get :index
      response.should render_template('members/index.html.erb')
    end
  end
  
  describe "Show" do
    before(:each) do
      @member = mock_model(Member,{:first_name => "Jigar", :last_name => "Patel"})
      @owned_businesses = mock_model(Business)
      @favorite_businesses = mock_model(Business)
      Member.stub!(:find_by_id).with("1").and_return(@member)
      @member.stub!(:owned_businesses).and_return(@owned_businesses)
      @member.stub!(:favorite_businesses).and_return(@favorite_businesses)
      @favorite_businesses.stub!(:paginate).and_return(@favotite_businesses)
      @owned_businesses.stub!(:paginate).and_return(@owned_businesses)
      session[:member_id] = "1"
    end
    
    describe "Profile" do
      it "should not allow non logged in users" do
        session[:member_id] = nil
        get :show
        response.should redirect_to(login_path)
      end
      
      it "should find member from session and return @member object" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        get :show
      end
    
      it "should find owned businesses" do
        @member.should_receive(:owned_businesses).and_return(@owned_businesses)
        get :show
      end
    
      it "should find favorite businesses " do
        @member.should_receive(:favorite_businesses).and_return(@favorite_businesses)
        get :show
      end
    
      it "should set the correct title" do
        get :show
        assigns[:title].should == "Jigar Patel"
      end
    end
    
    describe "My List" do
      it "should not allow non logged in users" do
        session[:member_id] = nil
        get :show_list
        response.should redirect_to(login_path)
      end
      
      it "should find member from session and return @member object" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        get :show_list
      end
      
      it "should find favorite businesses " do
        @member.should_receive(:favorite_businesses).and_return(@favorite_businesses)
        get :show_list
      end
      
      it "should set the correct title" do
        get :show_my_businesses
        assigns[:title].should == "Jigar Patel"
      end
    end
    
    describe "My Businesses" do
      it "should not allow non logged in users" do
        session[:member_id] = nil
        get :show_my_businesses
        response.should redirect_to(login_path)
      end
      
      it "should find member from session and return @member object" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        get :show_my_businesses
      end
      
      it "should find owned businesses " do
        @member.should_receive(:owned_businesses).and_return(@owned_businesses)
        get :show_my_businesses
      end
      
      it "should set the correct title" do
        get :show_my_businesses
        assigns[:title].should == "Jigar Patel"
      end
    end
  end
  
  describe "Signup" do
    it "should allow non logged in users" do
      get :new
      response.should be_success
    end
  end
end