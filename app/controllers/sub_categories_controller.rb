class SubCategoriesController < ApplicationController

  def index
    @search_query = params[:search][SEARCH_REGEX,2]
    @sub_categories = SubCategory.find(:all, :conditions => ['sub_category LIKE ?', "%#{@search_query}%"])
  end  
  
end
