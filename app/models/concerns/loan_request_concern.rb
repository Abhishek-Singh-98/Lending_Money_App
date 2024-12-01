module LoanRequestConcern
  extend ActiveSupport::Concern

  included do

    before_save do
      if new_record?
        add_status_of_loan
        add_special_request_id
      end
    end

    after_update do
      check_status_and_update_wallet
    end

  end

  def add_special_request_id
    Rails.logger.debug "Setting default special id"
    special_id = self.class.last&.special_request_id
    code = special_id.nil? ? 0 : special_id.match(/TESTLOAN(\d+)SPC/)[1].to_i
    self.special_request_id = "TESTLOAN#{code + 1}SPC"
  end

  def add_status_of_loan
    Rails.logger.debug "Setting default status"
    self.status = 'requested'
  end

  def check_status_and_update_wallet
    admin_wallet = User.find{|u| u.Admin?}.wallet
    user_wallet = self.user.wallet
    if status == 'open' && amount_payable.nil?
      admin_wallet.update_column(:amount, admin_wallet.amount - desired_amount)
      user_wallet.update_column(:amount, user_wallet.amount + desired_amount)
    elsif status == 'open' && !amount_payable.nil?
      check_wallet_amount_with_interest(user_wallet)
    end
  end

  def check_wallet_amount_with_interest(user_wallet)
    unless self.amount_payable <= user_wallet.max_limit
      loan_transaction(self, self.user, 'model')
      self.update(status: 'closed')
    end
  end
end