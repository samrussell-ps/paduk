class Turn < ActiveRecord::Base
  has_many :stone_additions, dependent: :destroy, class_name: 'StoneOperationAddition'
  has_many :stone_removals, dependent: :destroy, class_name: 'StoneOperationRemoval'

  def self.ordered(id = nil)
    if id
      where('id <= ?', id).order(:created_at)
    else
      all.order(:created_at)
    end
  end

  def self.with_table_lock
    transaction do
      ActiveRecord::Base.connection.execute('LOCK TABLE Turns')

      yield
    end
  end
end
