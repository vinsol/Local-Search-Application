class JoinTableCategorySubCategory < ActiveRecord::Migration
  def self.up
    create_table :categories_sub_categories, :id => false do |t|
      t.references :category, :sub_category
    end
    add_index "categories_sub_categories", "category_id"

    add_index "categories_sub_categories", "sub_category_id"
  end

  def self.down
    drop_table :categories_sub_categories
  end
end
