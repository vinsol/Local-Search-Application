require 'spec_helper'

describe Admin::AdminController do

  before(:each) do
    @member = mock_model(Member)
    Member.stub!(:find_by_id).with("1").and_return(@member) 
    session[:member_id] = "1"
  end
  
  it "should test allow admin users only" do
    @member.stub!(:is_admin).and_return(true)
    get :index
    response.should render_template("admin/admin/index.html.erb")
  end
  
  it "should redirect non admin users" do
    @member.stub!(:is_admin).and_return(false)
    get :index
    response.should redirect_to(root_path)
  end
end
