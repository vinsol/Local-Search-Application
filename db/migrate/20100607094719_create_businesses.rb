class CreateBusinesses < ActiveRecord::Migration
  def self.up
    create_table :businesses do |t|
      t.integer :member_id
      t.string :name, :location, :city, :category
      t.string :status, :default => "unverified"
      t.timestamps
    end
  end

  def self.down
    drop_table :businesses
  end
end
