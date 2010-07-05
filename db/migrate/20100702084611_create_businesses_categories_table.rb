class CreateBusinessesCategoriesTable < ActiveRecord::Migration
  def self.up
    create_table :businesses_categories, :id => false do |t|
      t.references :business, :category
    end
    add_index "businesses_categories", "business_id"

    add_index "businesses_categories", "category_id"
  end

  def self.down
    drop_table :businesses_categories
  end
end
