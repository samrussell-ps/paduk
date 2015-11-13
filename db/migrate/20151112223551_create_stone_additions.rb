class CreateStoneAdditions < ActiveRecord::Migration
  def change
    create_table :stone_additions do |t|
      t.integer :row
      t.integer :column
      t.integer :turn_id

      t.timestamps null: false
    end
  end
end
