class Admin::OrdersController < ApplicationController
  before_filter :check_admin
  active_scaffold :order do |config|
    config.columns = [ :business, :name, :order_transactions, :ip_address, :card_type, :address1, :city, :state, :country]
  end
end
