require 'spec_helper'

describe Admin::CategoriesHelper do
  fixtures :categories, :sub_categories
  
  it "should return sub_categories if record has any sub cats" do
    record = categories(:categories_001)
    helper.sub_categories_column(record).should_not be_empty
  end
  
end