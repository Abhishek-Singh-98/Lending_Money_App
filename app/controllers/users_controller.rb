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
    @loan_requests = @user.loan_requests
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
