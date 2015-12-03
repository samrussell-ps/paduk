class MakeKindFromType < ActiveRecord::Migration
  TYPES_TO_KINDS = {
    'StoneOperationAddition' => 'addition',
    'StoneOperationRemoval' => 'removal'
  }

  def up
    StoneOperation.find_each do |stone_operation|
      stone_operation.kind = TYPES_TO_KINDS[stone_operation.type]
      stone_operation.save!
    end
  end

  def down
    StoneOperation.find_each do |stone_operation|
      stone_operation.kind = nil
      stone_operation.save!
    end
  end
end
