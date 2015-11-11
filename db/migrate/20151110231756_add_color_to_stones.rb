class AddColorToStones < ActiveRecord::Migration
  def change
    add_column :stones, :color, :string
  end
end
