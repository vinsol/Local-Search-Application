# == Schema Information
# Schema version: 20100618113518
#
# Table name: categories
#
#  id         :integer(4)      not null, primary key
#  created_at :datetime
#  updated_at :datetime
#  category   :string(255)
#

class Category < ActiveRecord::Base
  validates_presence_of :category
  has_and_belongs_to_many :sub_categories
end
