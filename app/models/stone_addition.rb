class StoneAddition < ActiveRecord::Base
  belongs_to :turn

  # TODO validate all presence on one row
  # validates [:turn, :row, :column], presence: true
  validates :turn, presence: true

  validates :row, presence: true
  # TODO use numericality, it builds message for free
  validates :row, inclusion: { 
    in: (0...Board::NUMBER_OF_ROWS),
    message: "row is %{value}, it must be 0 <= value < #{Board::NUMBER_OF_ROWS}"
  }

  validates :column, presence: true
  validates :column, inclusion: {
    in: (0...Board::NUMBER_OF_COLUMNS),
    message: "column is %{value}, it must be 0 <= value < #{Board::NUMBER_OF_COLUMNS}"
  }

  def to_coordinate
    Coordinate.new(row: row, column: column)
  end
end
