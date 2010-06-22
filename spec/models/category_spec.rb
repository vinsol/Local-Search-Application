require 'spec_helper'

describe Category do
  fixtures :categories, :sub_categories, :categories_sub_categories
  before(:each) do
    @valid_attributes = { :category => "Healthcare" }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end
  
  it "should require valid category" do
    Category.new(:category => " ").should_not be_valid
  end
  
  it "should have a sub-category" do
    @category = Category.find(categories(:healthcare))
    @category.sub_categories.should_not be_empty
  end
end
