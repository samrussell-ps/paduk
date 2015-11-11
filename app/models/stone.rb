class Stone < ActiveRecord::Base
  validates :row, presence: true
  validates :column, presence: true
  validates :color, presence: true
  validates :color, inclusion: {
    in: %w(black white),
    message: "color is %{value}, it must be either black or white"
  }
end
