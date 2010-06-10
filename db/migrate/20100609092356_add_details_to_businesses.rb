class AddDetailsToBusinesses < ActiveRecord::Migration
  def self.up
    add_column :businesses, :contact_name, :string
    add_column :businesses, :contact_phone, :string
    add_column :businesses, :contact_email, :string
    add_column :businesses, :contact_website, :string
    add_column :businesses, :contact_address, :string
    add_column :businesses, :photo_album, :string
    add_column :businesses, :map, :string
    add_column :businesses, :description, :text
    add_column :businesses, :opening_time, :datetime
    add_column :businesses, :closing_time, :datetime
    
   
  end

  def self.down
    remove_column :businesses, :contact_name
    remove_column :businesses, :contact_phone
    remove_column :businesses, :contact_email
    remove_column :businesses, :contact_website
    remove_column :businesses, :contact_address
    remove_column :businesses, :photo_album
    remove_column :businesses, :map
    remove_column :businesses, :description
    remove_column :businesses, :opening_time
    remove_column :businesses, :closing_time
  end
end
