class Turn < ActiveRecord::Base
  # TODO look at keeping these the same, STI or relations
  # maybe type/kind column
  has_many :stone_additions
  has_many :stone_removals

  def self.ordered(id = nil)
    if id
      Turn.where('id <= ?', id).order(:created_at)
    else
      Turn.all.order(:created_at)
    end
  end
end
