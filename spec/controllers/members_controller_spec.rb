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
      @member.stub!(:full_name).and_return("Jigar Patel")
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
      
      it "should render show template" do
        get :show
        response.should render_template('members/show.html.erb')
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
      
      it "should render show_list template" do
        get :show_list
        response.should render_template('members/show_list.html.erb')
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
      
      it "should render show_my_businesses template" do
        get :show_my_businesses
        response.should render_template('members/show_my_businesses.html.erb')
      end
    end
  end
  
  describe "Signup" do
    before(:each) do
      @member = mock_model(Member)
      Member.stub!(:new).and_return(@member)
    end
    
    it "should allow non logged in users" do
      get :new
      response.should be_success
    end
    
    it "should create a new instance of Member class" do
      Member.should_receive(:new).and_return(@member)
      get :new
    end
    
    it "should render new member template" do
      get :new
      response.should render_template('members/new.html.erb')
    end
  end
  
  describe "Edit" do
    before(:each) do
      @member = mock_model(Member,{ :id => "1"})
      Member.stub!(:find_by_id).with("1").and_return(@member)
      session[:member_id] = "1"
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      get :edit
      response.should redirect_to(login_path)
    end
    
    it "should find the member from session and return @member" do
      Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
      get :edit
    end
    
    it "should set the correct title" do
      get :edit
      assigns[:title].should == "Edit Profile"
    end
    
    it "should render edit template" do
      get :edit
      response.should render_template('members/edit.html.erb')
    end
  end

  describe "Create" do
    
    it "should allow non logged in users" do
      post :create
      response.should be_success
    end
    
    describe "with valid attributes" do
      
      before(:each) do
        @member = mock_model(Member, :save => true)
        Member.stub!(:new).with('valid_attributes').and_return(@member)
      end
      
      it "should create a new Member instance with valid attributes" do
        Member.should_receive(:new).with('valid_attributes').and_return(@member)
        post :create, :member => "valid_attributes"
      end
    
      it "should save member with valid attributes" do
        @member.should_receive(:save).and_return(true)
        post :create, :member => "valid_attributes"
      end
      
      
      
      it "should set a flash message" do
        post :create, :member => "valid_attributes"
        flash[:message].should == "Signup successful. Please login using your credentials."
      end
      
      it "should redirect to login path" do
        post :create, :member => "valid_attributes"
        response.should redirect_to(login_path)
      end
    end
    
    describe "with invalid attributes" do
      
      before(:each) do
        @member = mock_model(Member, :save => false)
        Member.stub!(:new).with('invalid_attributes').and_return(@member)
      end
      
      it "should create a new Member instance with invalid attributes" do
        Member.should_receive(:new).with('valid_attributes').and_return(@member)
        post :create, :member => "valid_attributes"
      end
    
      it "should not save member with invalid attributes" do
        @member.should_receive(:save).and_return(false)
        post :create, :member => "invalid_attributes"
      end
      
      it "should render new template" do
        post :create, :member => "invalid_attributes"
        response.should render_template('members/new.html.erb')
      end

    end

  end
  
  describe "Update" do
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      put :update
      response.should redirect_to(login_path)
    end
    
    describe "with valid attributes" do
      
      before(:each) do
        @member = mock_model(Member, :update_attributes => true)
        Member.stub!(:find_by_id).with(1).and_return(@member)
        session[:member_id] = 1
      end
      
      it "should find member by session id" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        put :update, :member => "valid_attributes"
      end
      
      it "should update the member with valid attributes" do
        @member.should_receive(:update_attributes).and_return(true)
        put :update, :member => "valid_attributes"
      end
      
      it "should flash a message" do
        put :update, :member => "valid_attributes"
        flash[:message].should == "Profile was successfully edited"
      end
      
      it "should redirect to member profile path" do
        put :update, :member => "valid_attributes"
        response.should redirect_to(member_path(@member))
      end
    end
    
    describe "with invalid attributes" do
      before(:each) do
        @member = mock_model(Member, :update_attributes => false)
        @member.stub!(:update_attributes).with('invalid_attributes').and_return(false)
        Member.stub!(:find_by_id).with(1).and_return(@member)
        session[:member_id] = 1
      end
      
      it "should find member by session id" do
        Member.should_receive(:find_by_id).with(session[:member_id]).and_return(@member)
        put :update, :member => "invalid_attributes"
      end
      
      it "should not update the member with invalid parameters" do
        @member.stub!(:update_attributes).with('invalid_attributes').and_return(false)
        put :update, :member => "invalid_attributes"
      end
      
      it "should set a flash notice" do
        put :update, :member => "invalid_attributes"
        flash[:notice].should == "Profile not saved. Please check it again"
      end
      
      it "should redirect to edit member path" do
        put :update, :member => "invalid_attributes"
        response.should redirect_to(edit_member_path(@member.id))
      end
    end
    
  end
  
  describe "destroy" do
    before(:each) do
      @member = mock_model(Member, :destroy => true)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      delete :destroy
      response.should redirect_to(login_path)
    end
    
    it "should find member from session" do
      Member.should_receive(:find_by_id).with(1).and_return(@member)
      delete :destroy
    end
    
    it "should redirect to logout path" do
      delete :destroy
      response.should redirect_to(logout_path)
    end
  end
  
  describe "change password" do
    
    before(:each) do
      Member.stub!(:find_by_id).with(1).and_return(mock_model(Member))
      session[:member_id] = 1
    end
      
    it "should not allow non logged in users" do
      session[:member_id] = nil
      xhr :get, :change_password
      response.should redirect_to(login_path)
    end
      
    it "should find member using session" do
      Member.should_receive(:find_by_id).with(1).and_return(mock_model(Member))
      xhr :get, :change_password
    end
    
    it "should respond render change password rjs" do
      xhr :get, :change_password
      response.should render_template('members/change_password.js.rjs')
    end
  end
  
  describe "update password with valid password" do
    before(:each) do
      @member = mock_model(Member,:update_attributes => true)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @member.stub!(:password_change=).and_return(true)
      @member.stub!(:update_attributes).with("valid_attributes").and_return(true)
      session[:member_id] = 1
    end
    
    it "should not allow non logged in users" do
      session[:member_id] = nil
      xhr :post, :update_password
      response.should redirect_to(login_path)
    end
    
    it "should find member from session" do
      Member.should_receive(:find_by_id).with(1).and_return(@member)
      xhr :post, :update_password, :member => "valid_attributes"
    end
    
    it "should set password change attribute to true" do
      @member.stub!(:password_change=).and_return(true)
      xhr :post, :update_password, :member => "valid_attributes"
    end
    
    it "should update the password" do
      @member.stub!(:update_attributes).with("valid_attributes").and_return(true)
      xhr :post, :update_password, :member => "valid_attributes"
    end
    
    it "should set correct flash message" do
      @controller.instance_eval{flash.stub!(:sweep)}
      xhr :post, :update_password, :member => "valid_attributes"
      flash.now[:message].should == "Password Changed"
    end
    
    it "should render update password rjs template" do
      xhr :post, :update_password, :member => "valid_attributes"
      response.should render_template('members/update_password.js.rjs')
    end
  end
  
  describe "update password with in valid password" do
    before(:each) do
      @member = mock_model(Member,:update_attributes => false)
      Member.stub!(:find_by_id).with(1).and_return(@member)
      @member.stub!(:password_change=).and_return(true)
      @member.stub!(:update_attributes).with("invalid_attributes").and_return(false)
      session[:member_id] = 1
    end
    
    it "should  not update an invalid password" do
      @member.stub!(:update_attributes).with("invalid_attributes").and_return(false)
      xhr :post, :update_password, :member => "valid_attributes"
    end
    
    it "should set correct flash notice" do
      @controller.instance_eval{flash.stub!(:sweep)}
      xhr :post, :update_password, :member => "invalid_attributes"
      flash.now[:notice].should == "Password not changed. Try again"
    end
    
    it "should render change password template" do
      xhr :post, :update_password, :member => "valid_attributes"
      response.should render_template("members/change_password.js.rjs")
    end
  end
  
  describe " GET forgot password" do
    
    it "should allow non logged in users" do
      get :forgot_password
      response.should be_success
    end
    
    it "should set correct title" do
      get :forgot_password
      assigns[:title].should == "Forgot Password"
    end
    
    it "should render forgot password template" do
      get :forgot_password
      response.should render_template("members/forgot_password.html.erb")
    end
  end
  
  describe " POST forgot password" do
    
    describe "with valid email" do
      before(:each) do
        @member = mock_model(Member)
        Member.stub!(:find_by_email).with("valid_email").and_return(@member)
        @member.stub!(:send_new_password).and_return(true)
      end
      
      it "should find member by email" do
        Member.should_receive(:find_by_email).with("valid_email").and_return(@member)
        post :forgot_password, :member => {:email => "valid_email"}
      end
      
      it "should send a new password" do
        @member.should_receive(:send_new_password).and_return(true)
        post :forgot_password, :member => {:email => "valid_email"}
      end
      
      it "should set flash message" do
        post :forgot_password, :member => {:email => "valid_email"}
        flash[:message].should == "A new password has been sent by email."
      end
      
      it "should redirect to login path" do
        post :forgot_password, :member => {:email => "valid_email"}
        response.should redirect_to(login_path)
      end
      
      describe "with invalid email" do
        before(:each) do
          @member = mock_model(Member)
          Member.stub!(:find_by_email).with("invalid_email").and_return(false)
        end

        it "should not find a member with invalid email" do
          Member.should_receive(:find_by_email).with("invalid_email").and_return(false)
          post :forgot_password, :member => {:email => "invalid_email"}
        end
        
        it "should set correct flash notice" do
          post :forgot_password, :member => {:email => "invalid_email"}
          flash[:notice].should == "Unable to send the password. Try again"
        end
        
        it "should render forgot passsword template" do
          post :forgot_password, :member => {:email => "invalid_email"}
          response.should render_template("members/forgot_password.html.erb")
        end
      end
     end
   end
end