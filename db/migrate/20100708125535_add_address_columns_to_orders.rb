class AddAddressColumnsToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :billing_address
    add_column :orders, :name, :string
    add_column :orders, :address1, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :country, :string
    add_column :orders, :zip, :integer
  end

  def self.down
    add_column :orders, :billing_address, :string
    remove_column :orders, :name
    remove_column :orders, :address1
    remove_column :orders, :city
    remove_column :orders, :state
    remove_column :orders, :country
    remove_column :orders, :zip
  end
end
