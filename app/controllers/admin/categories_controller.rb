class Admin::CategoriesController < ApplicationController
  before_filter :check_admin
  active_scaffold :category	do |config|
    config.columns = [:category]
  end
end
