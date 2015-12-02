class StoneOperation < ActiveRecord::Base
  belongs_to :turn

  validates :turn, :row, :column, presence: true

  validates :row, numericality: { 
    greater_than_or_equal_to: 0,
    less_than: Board::NUMBER_OF_ROWS
  }

  validates :column, numericality: { 
    greater_than_or_equal_to: 0,
    less_than: Board::NUMBER_OF_COLUMNS
  }

  def to_coordinate
    Coordinate.new(row: row, column: column)
  end
end
