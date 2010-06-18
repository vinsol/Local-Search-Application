class AddCityIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :city_id, :integer
  end

  def self.down
    remove_column :locations, :city_id
  end
end
