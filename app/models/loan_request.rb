class LoanRequest < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  has_many :loan_repay_requests

  enum status: {"requested": 0, "approved": 1, "open": 2, "closed": 3,
                    "rejected": 4, "waiting_for_adjustment_acceptance": 5, "readjustment_requested": 6}
                
  before_save do
    if new_record?
      add_status_of_loan
      add_special_request_id
    end
  end

  after_update do
    check_status_and_update_wallet
  end
  validates_presence_of :desired_amount, :desired_interest, :loan_tenure


  private
  def add_special_request_id
    special_id = self.class.last&.special_request_id
    code = special_id.nil? ? 0 : special_id.match(/TESTLOAN(\d+)SPC/)[1].to_i
    self.special_request_id = "TESTLOAN#{code + 1}SPC"
  end

  def add_status_of_loan
    self.status = 'requested'
  end

  def check_status_and_update_wallet
    admin_wallet = User.find{|u| u.Admin?}.wallet
    user_wallet = self.user.wallet
    if status == 'open'
      admin_wallet.update_column(:amount, admin_wallet.amount - desired_amount)
      user_wallet.update_column(:amount, user_wallet.amount + desired_amount)
    end
  end

end
