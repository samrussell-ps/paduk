require 'rails_helper'

describe PlaceStone do
  context 'multiple stones' do
    let(:locations) { [ [3, 4], [1, 1], [2, 2,], [5, 6] ] }
    before do
      locations.each { |location| PlaceStone.new(location[0], location[1]).call }
    end

    it 'alternates the stones colors' do
      stones = Stone.last(4)

      expect(stones[0].color).to eq(stones[2].color)
      expect(stones[1].color).to eq(stones[3].color)

      expect(stones[0].color).to_not eq(stones[1].color)
      expect(stones[0].color).to_not eq(stones[3].color)
      expect(stones[2].color).to_not eq(stones[1].color)
      expect(stones[2].color).to_not eq(stones[3].color)
    end

    it 'assigns colors "black" or "white" to stones' do
      stones = Stone.last(4)

      stones.each do |stone|
        expect(stone.color).to eq("black").or eq("white")
      end
    end
  end
end
