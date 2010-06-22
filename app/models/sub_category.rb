# == Schema Information
# Schema version: 20100618113518
#
# Table name: sub_categories
#
#  id           :integer(4)      not null, primary key
#  sub_category :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class SubCategory < ActiveRecord::Base
  validates_presence_of :sub_category
  has_and_belongs_to_many :categories
end
