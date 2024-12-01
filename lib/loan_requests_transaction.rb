module LoanRequestsTransaction

  def loan_transaction(loan_request,user,from='controller')
    @user = user
    @loan_request = loan_request
    @from= from
    deduct_from_user_wallet
    add_to_admin_wallet
  end 

  private

  def deduct_from_user_wallet
    user_wallet = @user.wallet
    user_wallet.update_column(:amount, user_wallet.amount - @loan_request.amount_payable) if @from == 'controller'
    user_wallet.update_column(:amount, user_wallet.amount - user_wallet.amount) if @from == 'model'
  end

  def add_to_admin_wallet
    admin_wallet = User.find{|u| u.Admin?}.wallet
    admin_wallet.update_column(:amount, admin_wallet.amount + @loan_request.amount_payable) if @from == 'controller'
    admin_wallet.update_column(:amount, admin_wallet.amount + @loan_request.desired_amount) if @from == 'model'
  end
end