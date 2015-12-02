class Turn < ActiveRecord::Base
  # TODO look at keeping these the same, STI or relations
  # maybe type/kind column
  has_many :stone_additions, dependent: :destroy
  has_many :stone_removals, dependent: :destroy

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
