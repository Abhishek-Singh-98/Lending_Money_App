class LoanRequestsController < ApplicationController
  before_action :check_login_user

  def index
    @loan_requests = LoanRequest.all
  end

  def new
  end

  def create
    @loan_request = @user.loan_requests.build(loan_params)
    if @loan_request.save
      redirect_to users_loan_path(user_id: @user.id), notice: 'Loan Request is send'
    else
      redirect_to user_path(id: @user.id), alert: "Couldn't process your loan request"
    end
  end

  def show
    @loan_request = LoanRequest.find(params[:id])
  end

  def edit
    @loan_request = LoanRequest.find(params[:id])
  end

  def update
    unless @loan_request.update(loan_params)
      # redirect_to 
    end
  end

  private

  def loan_params
    params.permit(:desired_amount, :desired_interest, :loan_tenure, :status, :start_date, :end_date,
                  :interest_payable, :amount_payable, :special_request_id)
  end
end
