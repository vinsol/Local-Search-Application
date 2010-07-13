class AddLatLngToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :lng, :decimal, :precision => 10, :scale => 7
    add_column :locations, :lat, :decimal, :precision => 10, :scale => 7
  end

  def self.down
    remove_column :locations, :lng
    remove_column :locations, :lat
  end
end
