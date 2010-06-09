class BusinessRelation < ActiveRecord::Base
  belongs_to :member
  belongs_to :business
  attr_accessible :member_id, :business_id, :status
  
end
