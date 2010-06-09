class AddDetailsToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :phone_number, :string
    add_column :members, :address, :string
  end

  def self.down
    remove_column :members, :address
    remove_column :members, :phone_number
  end
end
