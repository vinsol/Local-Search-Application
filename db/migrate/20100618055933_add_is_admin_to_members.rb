class AddIsAdminToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :is_admin, :boolean, :default => false
  end

  def self.down
    remove_column :members, :is_admin
  end
end
