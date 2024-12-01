require 'faker'
FactoryBot.define do
  factory :user do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email {Faker::Internet.email}
    contact_number {Faker::PhoneNumber.phone_number_with_country_code}
    password {'Pass@123'}
    password_confirmation {'Pass@123'}
    proof_type {'Aadhar Card'}
    valid_proof_id {Faker::Number.number(digits: 12)}
  end

  factory :admin, parent: :user do
    role {'Admin'}
  end

  factory :other_user, parent: :user do
    role {'Other'}
  end
end
