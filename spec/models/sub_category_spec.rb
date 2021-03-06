require 'spec_helper'

describe SubCategory do
  fixtures :businesses, :sub_categories, :businesses_sub_categories, :categories_sub_categories, :categories
  before(:each) do
    @valid_attributes = { :sub_category => "chemist"}
    
  end

  it "should create a new instance given valid attributes" do
    SubCategory.create!(@valid_attributes)
  end
  
  it "should require a valid sub-category name" do
    SubCategory.new(:sub_category => " ").should_not be_valid
  end
  
  it "should have a associated category" do
    @sub_category = SubCategory.find(sub_categories(:sub_categories_012))
    @sub_category.categories.should_not be_empty
  end
end
