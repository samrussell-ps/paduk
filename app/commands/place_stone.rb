class PlaceStone
  COLORS = %w(black white)
  def initialize(row, column)
    @row = row
    @column = column
  end

  def call
    Stone.transaction do
      last_stone = Stone.last

      color = if last_stone
                next_color(last_stone.color)
              else
                COLORS.first
              end

      Stone.create!(row: @row, column: @column, color: color)
    end
  end

  private

  def next_color(color)
    last_color_index = COLORS.index(color)

    next_color_index = (last_color_index + 1) % COLORS.size

    COLORS[next_color_index]
  end
end
