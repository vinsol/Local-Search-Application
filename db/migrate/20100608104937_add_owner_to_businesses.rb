class AddOwnerToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :owner, :string
  end

  def self.down
    remove_column :businesses, :owner
  end
end
