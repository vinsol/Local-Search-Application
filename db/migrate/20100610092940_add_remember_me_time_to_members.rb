class AddRememberMeTimeToMembers < ActiveRecord::Migration
  def self.up
    add_column :members, :remember_me_time, :datetime
  end

  def self.down
    remove_column :members, :remember_me_time
  end
end
