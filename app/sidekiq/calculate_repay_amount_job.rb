class CalculateRepayAmountJob
  include Sidekiq::Job
  sidekiq_options queue: 'critical', retry: true

  def perform
    @loan_requests = LoanRequest.where(status: 'open', interest_payable: nil)
    @loan_requests.each do |loan|
      total_to_pay, interest_to_pay = calculate_interest_and_amount(loan)
      loan.update(amount_payable: total_to_pay, interest_payable: interest_to_pay)
      puts 'Performing calculation here'
    end
    self.class.perform_in(5.minutes)
  end

  private
  def calculate_interest_and_amount(loan)
    time = loan.loan_tenure
    principle = loan.desired_amount
    interest_rate = loan.desired_interest
    total_amount = principle * (1 + (interest_rate / 100.0))**(time / 12.0)
    interest_amount = total_amount - principle
    return [total_amount, interest_amount]
  end
end
