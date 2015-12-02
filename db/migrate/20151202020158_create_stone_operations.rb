class CreateStoneOperations < ActiveRecord::Migration
  def change
    create_table :stone_operations do |t|
      t.string :type
      t.integer :row
      t.integer :column
      t.integer :turn_id

      t.timestamps null: false
    end
  end
end
