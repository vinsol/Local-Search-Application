# == Schema Information
# Schema version: 20100618113518
#
# Table name: business_relations
#
#  id          :integer(4)      not null, primary key
#  member_id   :integer(4)
#  business_id :integer(4)
#  status      :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class BusinessRelation < ActiveRecord::Base
  belongs_to :member
  belongs_to :business
  attr_accessible :member_id, :business_id, :status
  
end
