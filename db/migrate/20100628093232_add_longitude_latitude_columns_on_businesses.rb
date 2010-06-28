class AddLongitudeLatitudeColumnsOnBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :lng, :decimal, :precision => 10, :scale => 7
    add_column :businesses, :lat, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    remove_column :businesses, :lng
    remove_column :businesses, :lat
  end
end
