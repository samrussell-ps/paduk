class Turn < ActiveRecord::Base
  has_many :stone_additions
  has_many :stone_removals
end
