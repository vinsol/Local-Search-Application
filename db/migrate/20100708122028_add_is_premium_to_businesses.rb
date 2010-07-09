class AddIsPremiumToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :is_premium, :string
  end

  def self.down
    remove_column :businesses, :is_premium
  end
end
