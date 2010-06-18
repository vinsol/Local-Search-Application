class Admin::SubcategoriesController < ApplicationController
  before_filter :check_admin
  active_scaffold :sub_category	do |config|
    config.columns = [:sub_category]
  end
end
