class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JwtAuthentication

  private
  def check_login_user
    begin
      @token = JwtAuthentication.decode(session[:token]) if session[:token]
      @user = User.find_by(id: @token['id']) if @token
      unless @user.present?
        flash[:alert] = "No Such User Present."
        redirect_to new_login_path
      end
    rescue
      flash[:alert] = @token.errors['token']
      redirect_to new_login_path
    end
  end

  def unautorized_other_user
    if ['approved', 'rejected'].include?(params[:status]) && @user.Other?
      return user_my_loans_path(user_id: @user.id), alert: 'Unauthorized action'
    end
  end

  def unauthorized_admin_user
    if ['true', 'false'].include?(params[:status]) && @user.Admin?
      return user_loan_requests_path, alert: 'Unauthorized action'
    end
  end

  def check_editable_condition
    if ['rejected', 'closed', 'open', 'approved'].include?(@loan_request.status)
      flash[:alert] = "Loan request is already #{@loan_request.status}."
      return redirect_to edit_user_loan_request_path(user_id: @user.id, id: @loan_request.id)
    end
  end
end
