class CreateBusinessRelations < ActiveRecord::Migration
  def self.up
    create_table :business_relations do |t|
      t.integer :member_id
      t.integer :business_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :business_relations
  end
end
