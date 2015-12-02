class Turn < ActiveRecord::Base
  has_many :stone_additions, dependent: :destroy, class_name: 'StoneOperationAddition'
  has_many :stone_removals, dependent: :destroy, class_name: 'StoneOperationRemoval'

  def self.ordered(id = nil)
    if id
      # TODO arel - shouldn't have bare "id", can't use #{table_name}
      where(arel_table[:id].lteq(id)).order(:created_at)
    else
      all.order(:created_at)
    end
  end

  def self.with_table_lock
    transaction do
      ActiveRecord::Base.connection.execute("LOCK TABLE #{table_name}")

      yield
    end
  end
end
