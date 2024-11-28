class LoanRepayHistory < ApplicationRecord
  belongs_to :user
  belongs_to :loan_request
end
