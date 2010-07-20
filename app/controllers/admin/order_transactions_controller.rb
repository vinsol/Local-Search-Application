class Admin::OrderTransactionsController < ApplicationController
  before_filter :check_admin
  active_scaffold :order_transactions	do |config|
    config.subform.columns.exclude :params, :created_at, :updated_at, :authorization
    
     
  end
end
