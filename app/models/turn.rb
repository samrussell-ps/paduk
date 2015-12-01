class Turn < ActiveRecord::Base
  # TODO look at keeping these the same, STI or relations
  # maybe type/kind column
  has_many :stone_additions
  has_many :stone_removals
end
