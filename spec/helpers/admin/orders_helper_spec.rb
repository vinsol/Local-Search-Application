require 'spec_helper'

describe Admin::OrdersHelper do
  fixtures :orders, :order_transactions, :businesses
  
  it "should return order transactions if record has any OTs" do
    record = orders(:orders_037)
    helper.order_transactions_column(record).should_not be_empty
  end
  
  it "should return business name for order" do
    record = orders(:orders_037)
    helper.business_column(record).should_not be_nil
  end
end