class StoneAddition < ActiveRecord::Base
  belongs_to :turn

  validates :turn, presence: true
  validates :row, presence: true
  validates :row, inclusion: { 
    in: (0...Stone::NUMBER_OF_ROWS),
    message: "row is %{value}, it must be 0 <= value < #{Stone::NUMBER_OF_ROWS}"
  }
  validates :column, presence: true
  validates :column, inclusion: {
    in: (0...Stone::NUMBER_OF_COLUMNS),
    message: "column is %{value}, it must be 0 <= value < #{Stone::NUMBER_OF_COLUMNS}"
  }
end
