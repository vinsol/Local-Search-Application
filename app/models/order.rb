class Order < ActiveRecord::Base
  has_many :order_transactions
  attr_accessor :card_number, :card_verification
  
  before_validation_on_create :valid_card
  validates_presence_of :address1, :city, :state, :country, :zip, :card_number, :card_type, :card_verification
  validates_format_of :zip, :with => /^\d{5}$/,
                            :message => " code must be a 5 digit number."
  
  def purchase
    response = GATEWAY.purchase(5000, credit_card, purchase_details)
    order_transactions.create(:action => "purchase", :amount => 5000, :response => response)
    if response.success?
      @business = Business.find_by_id(business_id)
      @business.update_attribute(:is_premium, PREMIUM)
    end
    return response
  end
  
  private
  
  def purchase_details
    {
      :ip => ip_address,
      :billing_address => {
        :name => name,
        :address1 => address1,
        :city => city,
        :state => state,
        :country => country,
        :zip => zip
      }
    }
  end
  
  def valid_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
        p message
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type => card_type,
      :number => card_number,
      :verification_value => card_verification,
      :month => card_expires_on.month,
      :year => card_expires_on.year,
      :first_name => first_name,
      :last_name => last_name
      )
  end
end
