FactoryBot.define do
  factory :loan_request do
    desired_amount {5000.0}
    desired_interest {10.0}
    user_id {FactoryBot.create(:other_user).id}
    loan_tenure{6}
  end
end
