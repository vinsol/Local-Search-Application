require 'spec_helper'

describe Admin::MembersHelper do
  fixtures :members
  before(:each) do
    @member = members(:members_001)
    
  end
  
  it "should return admin status" do
    helper.is_admin_column(@member).should == true
  end
end