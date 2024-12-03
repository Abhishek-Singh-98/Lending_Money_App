class LoanRequest < ApplicationRecord
  include LoanRequestConcern
  include LoanRequestsTransaction
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :loan_request_readjustments

  accepts_nested_attributes_for :loan_request_readjustments, allow_destroy: true

  enum status: {"requested": 0, "approved": 1, "open": 2, "closed": 3, "rejected": 4,
  "waiting_for_adjustment_acceptance": 5, "readjustment_requested": 6}
                
  validates_presence_of :desired_amount, :desired_interest, :loan_tenure

end
