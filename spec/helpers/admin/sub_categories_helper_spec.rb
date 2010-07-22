require 'spec_helper'

describe Admin::SubCategoriesHelper do
  fixtures :categories, :sub_categories
  
  it "should return categories if record has any categories" do
    record = sub_categories(:sub_categories_002)
    helper.categories_column(record).should_not be_empty
  end
  
end