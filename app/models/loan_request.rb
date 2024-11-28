class LoanRequest < ApplicationRecord
  belongs_to :user
  has_many :loan_repay_requests

  enum status: {"requested": 0, "approved": 1, "open": 2, "closed": 3,
                    "rejected": 4, "waiting_for_adjustment_acceptance": 5, "readjustment_requested": 6}
                
  validates_presence_of :desired_amount, :desired_interest, :loan_tenure, :status, :special_request_id

  before_save :add_special_request_id


  private
  def add_special_request_id
    if new_record?
      special_id = self.class.last.special_request_id
      code = special_id.match(/TESTLOAN(\d+)SPC/)[1].to_i || 0
      self.add_special_request_id = "TESTLOAN#{code + 1}SPC"
    end
  end

end
