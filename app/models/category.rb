class Category < ActiveRecord::Base
  validates_presence_of :category
  has_and_belongs_to_many :sub_categories
end
