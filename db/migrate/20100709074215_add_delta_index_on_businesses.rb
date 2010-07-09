class AddDeltaIndexOnBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :delta, :boolean, :default => true,
        :null => false
  end

  def self.down
    remove_column :businesses, :delta
  end
end
