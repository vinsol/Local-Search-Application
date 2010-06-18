class Admin::CitiesController < ApplicationController
  before_filter :check_admin
  active_scaffold :city	do |config|
    config.columns = [:city, :id]
  end
end
