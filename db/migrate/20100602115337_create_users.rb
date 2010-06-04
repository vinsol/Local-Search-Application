class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :full_name
      t.string :salt
      t.string :hashed_password
      t.string :role

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
