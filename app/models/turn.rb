class Turn < ActiveRecord::Base
  has_many :stone_additions, -> { where(kind: 'addition') }, class_name: 'StoneOperation'
  has_many :stone_removals, -> { where(kind: 'removal') }, class_name: 'StoneOperation'

  def self.ordered(id = nil)
    if id
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
