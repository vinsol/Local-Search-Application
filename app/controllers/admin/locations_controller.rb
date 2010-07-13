class Admin::LocationsController < ApplicationController
  before_filter :check_admin
  active_scaffold :location	do |config|
    config.columns = [:location,:lat,:lng]
  end
end
