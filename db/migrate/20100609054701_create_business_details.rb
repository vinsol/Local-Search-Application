class CreateBusinessDetails < ActiveRecord::Migration
  def self.up
    create_table :business_details do |t|
      t.string :state, :contact_name, :contact_phone, :contact_email, :contact_website, :contact_address
      t.datetime :opening_time, :closing_time
      t.text :description
      t.string :photo_album, :map
      t.timestamps
    end
  end

  def self.down
    drop_table :business_details
  end
end
