require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#associations' do
    context 'must pass the association cases' do
      it { should have_one(:wallet) }
      it { should have_many(:loan_requests)}
    end
  end

  describe '#validation' do
    context 'must pass the validation of presence' do
      it { should validate_presence_of(:first_name) }
      it { should validate_presence_of(:last_name) }
      it { should validate_presence_of(:email) }
      it { should validate_presence_of(:role) }
      it { should validate_presence_of(:contact_number) }
      it { should validate_presence_of(:proof_type)}
      it { should validate_presence_of(:valid_proof_id)}
    end
  end

  describe '#association' do
    context 'must pass the association of presence' do
      it { should validate_uniqueness_of(:email) }
      it { should validate_uniqueness_of(:contact_number) }
      it { should validate_uniqueness_of(:valid_proof_id) }
    end
  end
end
