require 'rails_helper'

RSpec.describe Turn, type: :model do
  context 'with no additions, no removals' do
    subject { Turn.create }

    it { is_expected.to be_valid }
  end
end
