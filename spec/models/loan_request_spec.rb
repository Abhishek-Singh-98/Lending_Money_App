require 'rails_helper'

RSpec.describe LoanRequest, type: :model do
  describe '#associations' do
    context 'must pass the association cases' do
      it { should belong_to(:user) }
    end
  end

  describe '#validation' do
    context 'must pass the validation of presence' do
      it { should validate_presence_of(:desired_amount) }
      it { should validate_presence_of(:desired_interest) }
      it { should validate_presence_of(:loan_tenure) }
    end
  end
end
