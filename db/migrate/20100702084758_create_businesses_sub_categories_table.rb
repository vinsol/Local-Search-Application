class CreateBusinessesSubCategoriesTable < ActiveRecord::Migration
  def self.up
    create_table :businesses_sub_categories, :id => false do |t|
      t.references :business, :sub_category
    end
    add_index "businesses_sub_categories", "business_id"

    add_index "businesses_sub_categories", "sub_category_id"
  end

  def self.down
    drop_table :businesses_sub_categories
  end
end
