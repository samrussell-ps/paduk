class Stone < ActiveRecord::Base
  validates :row, presence: true
  validates :column, presence: true
end
