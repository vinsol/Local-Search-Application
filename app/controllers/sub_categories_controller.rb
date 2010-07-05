class SubCategoriesController < ApplicationController

  def index
    search_reg_exp = /(?:([a-zA-Z0-9]*[\s,]+)*)([a-zA-Z0-9]+)$/
    @search_query = params[:search][search_reg_exp,2]
    @sub_categories = SubCategory.find(:all, :conditions => ['sub_category LIKE ?', "%#{@search_query}%"])
  end  
  
end
