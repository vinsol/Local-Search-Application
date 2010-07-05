class RemoveCategoryAndSubCategoryFromBusinesses < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :category
    remove_column :businesses, :sub_category
  end

  def self.down
    add_column :businesses, :category, :string
    add_column :businesses, :sub_category, :string
  end
end
