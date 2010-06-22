require 'spec_helper'

describe MembersController do

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
    
    it "should have right title" do
      get :new
      assigns[:title] == "Signup"
    end
    
    it "should render new member form" do
      get :new
      response.should render_template('members/new')
    end
  end


end
