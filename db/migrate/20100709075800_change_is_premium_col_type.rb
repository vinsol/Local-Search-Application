class ChangeIsPremiumColType < ActiveRecord::Migration
  def self.up
    change_column :businesses, :is_premium, :integer, :default => 0
  end

  def self.down
    remove_column :businesses, :is_premium
  end
end
