class Admin::BusinessesController < ApplicationController
  before_filter :check_admin
  active_scaffold :business	do |config|
    config.columns = [:name, :location, :city, :sub_categories, :owner, :status]
    config.subform.columns.exclude :sub_categories, :status, :location, :city
  end
  
end
