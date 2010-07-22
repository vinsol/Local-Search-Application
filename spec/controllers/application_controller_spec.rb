require 'spec_helper'

describe ApplicationController do
  
  describe "is logged in" do
    before(:each) do
      session[:member_id] = "id"
      Member.stub!(:find_by_id).and_return(nil)
    end
    
    it "should set logged in as false" do
      get :is_logged_in
      assigns[:logged_in].should be_false
    end
    
  end
end

