require 'spec_helper'

describe Order do
  before(:each) do
    @valid_order = { 
        :city => "Sterling Heights",
        :address1 => "Test Address",
        :name => "Jigar Patel",
        :zip => "48310",
        :updated_at => "2010-07-09 05:32:59",
        :card_type => "visa",
        :country => "US",
        :business_id => "61",
        :id => "16",
        :card_number => "4111111111111111",
        :card_verification => "123",
        :card_expires_on => "2010-07-01",
        :first_name => "Jigar",
        :last_name => "Patel",
        :state => "Michigan",
        :created_at => "2010-07-09 05:32:59",
        :ip_address => "127.0.0.1"
     
    }
  end

  it "should create a new instance given valid attributes" do
    @order = Order.create!(@valid_order)
  end
  
  it "should validate card data during saving an order" do
    order = Order.new(@valid_order.merge(:card_number => "123456789"))
  end
  
  it "GATEWAY should return successful response when valid credit card details are given" do
    @order = Order.create!(@valid_order)
    
    credit_card = mock_model(ActiveMerchant::Billing::CreditCard, { :type => "visa",
                                                                    :number => "1",
                                                                    :verification_value => "53433",
                                                                    :month => "07",
                                                                    :year => "2010",
                                                                    :first_name => "Jigar",
                                                                    :last_name => "Patel"})
    response = GATEWAY.purchase(5000, credit_card, { :ip => "127.0.0.1",
                                  :billing_address => { :name => "Jigar Patel",
                                                        :address1 => "Test Address",
                                                        :city => "Sterling Heights",
                                                        :state => "Michigan",
                                                        :country => "US",
                                                        :zip => "48310"}
                                                        }
                                                        )
   
   response.success?.should be_true
  end
  
  it "GATEWAY should return failed response when valid credit card details are given" do
    @order = Order.create!(@valid_order)
    
    credit_card = mock_model(ActiveMerchant::Billing::CreditCard, { :type => "visa",
                                                                    :number => "2",
                                                                    :verification_value => "53433",
                                                                    :month => "07",
                                                                    :year => "2010",
                                                                    :first_name => "Jigar",
                                                                    :last_name => "Patel"})
    response = GATEWAY.purchase(5000, credit_card, { :ip => "127.0.0.1",
                                  :billing_address => { :name => "Jigar Patel",
                                                        :address1 => "Test Address",
                                                        :city => "Sterling Heights",
                                                        :state => "Michigan",
                                                        :country => "US",
                                                        :zip => "48310"}
                                                        }
                                                        )
   puts response.success?
   puts response.message
   response.success?.should be_false
  end
end
