require 'spec_helper'

describe MembersController do
  
  def is_logged_in
     @member = mock_model(Member, {:full_name => "Name"})
     Member.stub!(:find_by_id).with("id").and_return(@member)
  end
  
  describe "Index" do
    before(:each) do
      @cities = [mock_model(City), mock_model(City)]
      City.stub!(:all).and_return(@cities)
      @categories = [mock_model(Category), mock_model(Category)]
      Category.stub!(:find).and_return(@categories)
    end
    
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :index
      response.should_not redirect_to(login_path)
    end
    
    it "should set correct title" do
      get :index
      assigns[:title].should_not be_nil
    end
    
    it "should find cities" do
      get :index
      assigns[:cities].should_not be_empty
    end
    
    it "should find categories" do
      get :index
      assigns[:categories].should_not be_empty
    end
  end
 
  describe "Show" do
    before(:each) do
      is_logged_in
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :show
      response.should redirect_to(login_path)
    end
    
    it "should set correct_title" do
      session[:member_id] = "id"
      get :show
      assigns[:title].should_not be_nil
    end
    
  end
  
  describe "Edit" do
    before(:each) do
      is_logged_in
    end
    
    it "should not allow non logged in members" do
      session[:member_id] = nil
      get :edit
      response.should redirect_to(login_path)
    end
    
    it "should set correct title" do
      session[:member_id] = "id"
      get :edit
      assigns[:title].should_not be_nil
    end
  end
  
  describe "Create" do
    before(:each) do
      @member = mock_model(Member, :save => false)
      Member.stub!(:new).and_return(@member)
    end
    
    it "should allow non logged in members" do
      session[:member_id] = nil
      post :create
      response.should_not redirect_to(login_path)
    end
    
    it "should render new action in case of save failure" do
      post :create
      response.should render_template("members/new.html.erb")
    end
    
    it "should set correct message on successful save" do
      @member.stub!(:save).and_return(true)
      post:create
      flash[:message].should == "Signup successful. Please login using your credentials."
    end
    
    it "should redirect to login path on successful save" do
      @member.stub!(:save).and_return(true)
      post:create
      response.should redirect_to(login_path)
    end
  end
  
  describe "Update" do
    before(:each) do
      is_logged_in
      session[:member_id] = "id"
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      put :update
      response.should redirect_to(login_path)
    end
    
    describe "in case of successful update" do
      before(:each) do
        @member.stub!(:update_attributes).and_return(true)
      end
      
      it "should set correct flash" do
        put :update
        flash[:message].should == "Profile was successfully edited"
      end
      
      it "should redirect to member path" do
        put :update
        response.should redirect_to(member_path(@member.id))
      end
    end
    
    describe "in case of update failure" do
      before(:each) do
        @member.stub!(:update_attributes).and_return(false)
      end
      
      it "should set correct flash notice" do
        put :update
        flash[:notice].should == "Profile not saved. Please check it again"
      end
      
      it "should redirect to edit page" do
        put :update 
        response.should redirect_to(edit_member_path(@member.id))
      end
    end

  end
  
  describe "Update password" do
    before(:each) do
      session[:member_id] = "id"
      is_logged_in
      
    end
    
    it "should not allow non logged user" do
      session[:member_id] = nil
      post :update_password
      response.should redirect_to(login_path)
    end
    
    describe "in case of successful update" do
      before(:each) do
        @member.stub!(:update_attributes).and_return(true)
        @member.should_receive(:password_change=)
      end
      
      it "should render correct template" do
        post :update_password
        response.should render_template("members/update_password.js.rjs")
      end
      
    end
    
    describe "in case of unsuccessful update" do
      before(:each) do
        @member.stub!(:update_attributes).and_return(false)
        @member.should_receive(:password_change=)
      end
      
      it "shuold render change password template" do
        post :update_password
        response.should render_template("members/update_password")
      end
    end
  end
  
  describe "Destroy" do
    before(:each) do
      is_logged_in
      @member.stub!(:destroy)
    end
    
    it "should not allow non logged in members" do
      session[:member_id] = nil
      delete :destroy
      response.should redirect_to(login_path)
    end
    
    it "should redirect to logout path on completion" do
      session[:member_id] = "id"
      delete :destroy
      response.should redirect_to(logout_path)
    end
  end
  
  describe "forgot password" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:find_by_email).and_return(@member)
    end
    
    it "should allow non logged in users" do
      session[:member_id] = nil
      get :forgot_password
      response.should_not redirect_to(login_path)
    end
    
    it "should set flash and redirect to login path in case of successful delivery" do
      @member.stub!(:send_new_password).and_return(true)
      post :forgot_password, :member => {:email => true}
      flash[:message].should == "A new password has been sent by email."
      response.should redirect_to(login_path)
    end
      
    it "shoud render forgot password in case of delivery failure" do
      @member.stub!(:send_new_password).and_return(false)
      post :forgot_password, :member => {:email => true}
      response.should render_template("members/forgot_password")
    end
    
    it "should render forgot password in case member is not found" do
      Member.stub!(:find_by_email).and_return(nil)
      post :forgot_password, :member => {:email => true}
      response.should render_template("members/forgot_password")
    end
  end
end