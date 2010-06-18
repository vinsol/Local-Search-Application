class AddCategoryToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :category, :string
  end

  def self.down
    remove_column :categories, :category
  end
end
