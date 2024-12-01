require 'rails_helper'

RSpec.describe Wallet, type: :model do
  describe '#associations' do
    context 'must pass the association cases' do
      it { should belong_to(:user) }
    end
  end
end
