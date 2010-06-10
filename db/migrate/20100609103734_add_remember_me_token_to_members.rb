class AddRememberMeTokenToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :remember_me_token, :string
  end

  def self.down
    remove_column :members, :remember_me_token
  end
end
