class RemoveTypeFromStoneOperations < ActiveRecord::Migration
  KINDS_TO_TYPES = {
    'addition' => 'StoneOperationAddition',
    'removal' => 'StoneOperationRemoval'
  }

  def up
    remove_column :stone_operations, :type, :string
  end

  def down
    add_column :stone_operations, :type, :string

    StoneOperation.find_each do |stone_operation|
      stone_operation.type = KINDS_TO_TYPES[stone_operation.kind]
      stone_operation.save!
    end
  end
end
