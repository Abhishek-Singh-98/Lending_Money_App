class UsersController < ApplicationController
  before_action :check_login_user

  def show
    return redirect_to '/login/new', alert: 'Illegal Action Found' if (@user.Other? && @user.id != params[:id].to_i)
    @user = User.find_by_id(params[:id])
    unless @user.present?
      return render :new, alert: "User didn't get added."
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update(update_params)
      redirect_to user_path(id: @user.id), notice: 'User update successfully'
    else
      redirect_to edit_user_path(id: @user.id), alert: 'Something went wrong'
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:notice] = 'User Succesfully Removed' 
      render 'signup_page', format: :html
    end   
  end

  def my_loans
    @loan_requests = @user.loan_requests.order(id: :desc)
  end

  def logout_user
    if session[:user_id] == params[:user_id].to_i
      session[:token] = nil
      session[:user_id] = nil
      flash[:notice] = 'Logged Out Succesfully'
      redirect_to new_login_path
    else
      flash[:alert] = 'Unauthorize to logout this account.'
      redirect_to user_path(id: params[:user_id]) 
    end
  end

  private
  def update_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :contact_number, :address, :proof_type,
                    :valid_proof_id, :password, :password_confirmation, :password_digest, :fraud)
  end

  # def appointment_params
  #   params.require(:appointment).permit(:patient_id, :doctor_id, :slot, :appointment_date)
  # end
end
