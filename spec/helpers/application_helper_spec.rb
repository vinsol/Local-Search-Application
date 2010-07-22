require 'spec_helper'

describe ApplicationHelper do
  
  def is_logged_in
     @member = mock_model(Member, {:full_name => "Name"})
     Member.stub!(:find_by_id).with("id").and_return(@member)
   end

   def find_business_by_id
     @business = mock_model(Business, {:name => "Name"})
     Business.stub!(:find_by_id).with("id").and_return(@business)
   end
   
  it "should set correct title " do
    @title = "Jigar"
    helper.title.should == " Local Product Search Engine"
  end
  
  describe "is favorite" do
    before(:each) do
      session[:return_to] = root_path
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
    end
    
    it "should return true if business is favorite" do
      @business_relations.stub!(:find).and_return(true)
      helper.is_favorite("id").should == true
    end
    
    it "should return false if business is not favorite" do
      @business_relations.stub!(:find).and_return(false)
      helper.is_favorite("id").should == false
    end
    
  end
  
  describe "is owner" do
    before(:each) do
      session[:return_to] = root_path
      session[:member_id] = "id"
      is_logged_in
      find_business_by_id
      @business_relations = mock_model(BusinessRelation)
      @business.stub!(:business_relations).and_return(@business_relations)
    end
    
    it "should return true if member is owner" do
      @business_relations.stub!(:find).and_return(true)
      helper.is_owner("id").should == true
    end
    
    it "should return false if member is not owner" do
      @business_relations.stub!(:find).and_return(false)
      helper.is_owner("id").should == false
    end
    
  end
  
end