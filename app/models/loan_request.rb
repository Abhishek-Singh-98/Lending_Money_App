class LoanRequest < ApplicationRecord
  include LoanRequestConcern
  include LoanRequestsTransaction
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :loan_repay_requests

  # before_update :check_status_for_editability

  enum status: {"requested": 0, "approved": 1, "open": 2, "closed": 3, "rejected": 4,
  "waiting_for_adjustment_acceptance": 5, "readjustment_requested": 6}
                
  # validates_presence_of :desired_amount, :desired_interest, :loan_tenure

  private
  # def check_status_for_editability
  #   LoanRequest.transaction do
  #     if ["readjustment_requested", "waiting_for_adjustment_acceptance", "requested"].exclude?(self.status)
  #       Rails.logger.error errors.full_messages
  #       throw(:abort)
  #     end
  #   end
  # end
end
