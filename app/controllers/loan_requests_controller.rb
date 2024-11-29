class LoanRequestsController < ApplicationController
  include UsersConcern
  before_action :check_login_user

  def index
    @loan_requests = LoanRequest.all
  end

  def new
  end

  def create
    @loan_request = LoanRequest.new(loan_params)
    @loan_request.user = @user
    if @loan_request.save
      redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), notice: 'Loan Request is send'
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
    @loan_request = LoanRequest.find(params[:id])
    unless @loan_request.present? && @loan_request.update(update_loan_params)
      return redirect_to edit_user_loan_request_path(user_id: @user.id, id: @loan_request.id), alert: 'Reqest failed to send'
    end
    update_status_according_to_role
    redirect_to user_loan_request_path(user_id: @user.id, id: @loan_request.id), notice: 'Request for re-approval sent successfully'
  end

  def admin_approve_reject_loan_request
    @loan_request = LoanRequest.find(params[:loan_request_id])
    begin
      user_type_loan_update
    rescue
      redirect_to user_my_loans_path(user_id: @user.id), alert: 'Something wrong happened.'
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
end
