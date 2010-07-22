require 'spec_helper'

describe OrderTransaction do
  before(:each) do
    
   
  end
  
  it "should set success, authorization, message and params attributes in case of successful purchase" do
    @credit_card = mock_model(ActiveMerchant::Billing::CreditCard, { :type => "visa",
                                                                    :number => "1",
                                                                    :verification_value => "53433",
                                                                    :month => "07",
                                                                    :year => "2010",
                                                                    :first_name => "Jigar",
                                                                    :last_name => "Patel"})
     @response = GATEWAY.purchase(5000, @credit_card, { :ip => "127.0.0.1",
                                    :billing_address => { :name => "Jigar Patel",
                                                          :address1 => "Test Address",
                                                          :city => "Sterling Heights",
                                                          :state => "Michigan",
                                                          :country => "US",
                                                          :zip => "48310"}
                                                          }
                                                          )
    @ot = OrderTransaction.new
    @ot.response=(@response)
    @ot.success.should be_true
    @ot.authorization.should == @response.authorization
    @ot.message.should_not be_nil
    @ot.params.should_not be_nil
   
  end
    
  
end
