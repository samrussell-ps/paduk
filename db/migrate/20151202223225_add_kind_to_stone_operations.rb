class AddKindToStoneOperations < ActiveRecord::Migration
  def change
    add_column :stone_operations, :kind, :string
  end
end
