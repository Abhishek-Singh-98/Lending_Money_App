class LoanRequestsController < ApplicationController
  include UsersConcern
  include LoanRequestsTransaction
  before_action :check_login_user
  before_action :check_open_loans, only: [:create]
  before_action :find_loan_request, only: [:show, :edit, :update, :admin_approve_reject_loan_request,
                :repay_full_loan]
  before_action :unauthorized_admin_user, :unautorized_other_user, only: [:admin_approve_reject_loan_request]
  before_action :check_editable_condition, only: [:update]
  before_action :check_wallet_balance, only: [:repay_full_loan]

  def index
    @loan_requests = LoanRequest.all.order(id: :desc)
  end

  def new
  end

  def create
    @loan_request = LoanRequest.new(loan_params)
    @loan_request.user = @user
    if @loan_request.save
      CalculateRepayAmountJob.perform_async
      redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), notice: 'Loan Request is send'
    else
      redirect_to user_path(id: @user.id), alert: "Couldn't process your loan request"
    end
  end

  def show
  end

  def edit
  end

  def update
    unless @loan_request.present? && @loan_request.update(update_loan_params)
      return redirect_to edit_user_loan_request_path(user_id: @user.id, id: @loan_request.id), alert: 'Reqest failed to send'
    end
    begin
      update_status_according_to_role
      redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), notice: 'Request for re-approval sent successfully'
    rescue 
      return redirect_to edit_user_loan_request_path(user_id: @user.id, id: @loan_request.id), alert: 'Reqest failed to send'
    end
  end

  def admin_approve_reject_loan_request
    begin
      user_type_loan_update
    rescue
      redirect_to user_my_loans_path(user_id: @user.id), alert: 'Something wrong happened.' if @user.Other?
      redirect_to user_loan_requests_path, alert: "Couldn't be approved" if @user.Admin?
    end
  end

  def repay_full_loan
    if @loan_request.present? && @loan_request.status == 'open'
      loan_transaction(@loan_request, @user)
      @loan_request.update(status: 'closed')
      redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), notice: "You have successfully Paid the loan"
    else
      redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), alert: "Something went wrong."
    end
  end 


  private

  def loan_params
    params.permit(:desired_amount, :desired_interest, :loan_tenure, :status, :start_date, :end_date,
                  :interest_payable, :amount_payable, :special_request_id)
  end

  def update_loan_params
    params.require(:loan_request).permit(:desired_amount, :desired_interest, :loan_tenure, :status, :start_date, :end_date,
                  :interest_payable, :amount_payable, :special_request_id)
  end

  def user_type_loan_update
    if @user.Admin?
      @loan_request.update(status: params[:status])
      redirect_to user_loan_requests_path, notice: "Loan Request for #{@loan_request.special_request_id} is #{params[:status]}"
    else
      user_approval = params[:status] == 'true' ? 'confirmed' : 'declined'
      params[:status] == 'true' ? @loan_request.update(user_confirmed: params[:status] == 'true', status: 'open', start_date: Date.today, end_date: Date.today + @loan_request.loan_tenure.months) : @loan_request.update(user_confirmed: params[:status] == 'true', status: 'rejected')
      redirect_to user_my_loans_path(user_id: @user.id), notice: "You have successfully #{user_approval} the #{@loan_request.special_request_id}"
    end
  end

  def check_open_loans
    if @user.loan_requests.where(status: 'open').any?
      redirect_to user_path(id: @user.id), alert: 'You already have an Active Loan.'
    end
  end

  def check_wallet_balance
    unless @user.wallet.amount >= @loan_request.amount_payable
      redirect_to user_wallet_path(user_id: @user.id), alert: 'Insufficient Balance'
    end
  end

  def find_loan_request
    @loan_request = params[:id].present? ? LoanRequest.find(params[:id]) : LoanRequest.find(params[:loan_request_id])
  end

  # def check_for_approved_status
  #   if @loan_request.status == 'approved'
  #     return redirect_to edit_user_loan_request_path(user_id: @user.id, id: @loan_request.id), alert: 'Loan is Already Approved'
  #   end
  # end
end
