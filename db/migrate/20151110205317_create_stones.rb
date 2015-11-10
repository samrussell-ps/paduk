class CreateStones < ActiveRecord::Migration
  def change
    create_table :stones do |t|
      t.integer :row
      t.integer :column

      t.timestamps null: false
    end
  end
end
