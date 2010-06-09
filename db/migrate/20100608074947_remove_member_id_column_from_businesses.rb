class RemoveMemberIdColumnFromBusinesses < ActiveRecord::Migration
  def self.up
    remove_column :businesses, :member_id
  end

  def self.down
    add_column :businesses, :member_id, :integer
  end
end
