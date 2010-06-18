class AddSubCategoryToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :sub_category, :string
  end

  def self.down
    remove_column :businesses, :sub_category
  end
end
