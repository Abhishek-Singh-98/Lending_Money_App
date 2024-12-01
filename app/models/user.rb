class User < ApplicationRecord
  include UserConcern
  has_secure_password

  has_one :wallet, class_name: "Wallet", dependent: :destroy
  has_many :loan_requests, class_name: "LoanRequest", dependent: :destroy

  validates_presence_of :first_name, :last_name, :email, :role, :contact_number,
                        :proof_type, :valid_proof_id

  validates_uniqueness_of :email, :contact_number, :valid_proof_id
  enum role: {'Admin': 0, 'Other': 1}
  enum proof_type: {'Aadhar Card': 0, 'Pan Card': 1, 'Passport Number': 2, 'Voter ID': 3}

end
