class ChangeDefaultValueOfDelta < ActiveRecord::Migration
  def self.up
    change_column :businesses, :delta, :boolean, :default => true,
        :null => false
  end

  def self.down
    change_column :businesses, :delta, :boolean, :default => true,
        :null => false
  end
end
