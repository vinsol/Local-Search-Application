require 'spec_helper'

describe Order do
  before(:each) do
    @valid_card = { :type => VISA,
    :number =>   4514883632506242,
    :verification_value => 123,
    :month => 07,
    :year => 2010,
    :first_name => Jigar,
    :last_name => Patel}
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end
end
