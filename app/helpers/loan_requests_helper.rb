module LoanRequestsHelper
  def can_approve_reject_request?(user, loan_request)
    user.Admin? && ['approved', 'open', 'closed', 'rejected'].exclude?(loan_request.status)
  end
  
  def can_confirm_decline_adjustments?(user, loan_request)
    user.Other? && ["approved", "waiting_for_adjustment_acceptance", "readjustment_requested"].include?(loan_request.status) && loan_request.user_confirmed.nil?
  end

  def repay_available?(user, loan_request)
    user.Other? && loan_request.status == 'open' && !loan_request.amount_payable.nil?
  end

  def re_adjust_available?(loan_request)
    ['approved', 'open', 'closed', 'rejected'].exclude?(loan_request.status)
  end
end
