class Stone < ActiveRecord::Base
  NUMBER_OF_ROWS = 19
  NUMBER_OF_COLUMNS = 19

  validates :row, presence: true
  validates :row, inclusion: {
    in: (0...NUMBER_OF_ROWS),
    message: "row is %{value}, it must be 0 <= value < #{NUMBER_OF_ROWS}"
  }
  validates :column, presence: true
  validates :column, inclusion: {
    in: (0...NUMBER_OF_COLUMNS),
    message: "column is %{value}, it must be 0 <= value < #{NUMBER_OF_COLUMNS}"
  }
  validates :color, presence: true
  validates :color, inclusion: {
    in: %w(black white),
    message: "color is %{value}, it must be either black or white"
  }
end
