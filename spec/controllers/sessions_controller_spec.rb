require 'spec_helper'

describe SessionsController do
  integrate_views
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      assigns[:title] == "Login"
      response.should be_success
    end
    
    it "should render new login form" do
      get :new
      response.should render_template('sessions/new.html.erb')
    end
  end


end
