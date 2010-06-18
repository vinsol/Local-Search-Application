class SubCategory < ActiveRecord::Base
  validates_presence_of :sub_category
  has_and_belongs_to_many :categories
end
