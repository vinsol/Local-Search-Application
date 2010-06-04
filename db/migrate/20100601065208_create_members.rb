class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
			
			t.string :email, :first_name, :last_name, :salt, :hashed_password
      t.timestamps
    end
  end

  def self.down
    drop_table :members
  end
end
