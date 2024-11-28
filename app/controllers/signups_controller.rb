class SignupsController < ApplicationController
  before_action :downcase_email, :authorize_user, :password_matching, :presence_of_admin, only: [:signup_user]
  
  def signup_page
    render 'signup_page', format: :html
  end

  def signup_user
      if @user.present?
        return render 'signup_page' , alert: 'Email already registered'
      end
      @user = User.new(signup_params)
      if @user.save
        flash[:notice] = 'SignUp Successfully Completed !!'
        redirect_to new_login_path  
      else
          render 'signup_page', format: :html
      end
  end

  private

  def signup_params
    params.require(:user).permit(:first_name, :last_name, :email, :role, :contact_number, :address, :proof_type,
                    :valid_proof_id, :password, :password_confirmation, :password_digest, :fraud)
  end

  def downcase_email
    params[:user][:email] = params[:user][:email].downcase
  end

  def authorize_user
    @user = User.find_by(email: params[:user][:email].downcase)
  end

  def password_matching
    unless params[:user][:password] == params[:user][:password_confirmation]
      return render 'signup_page' , alert: 'Please Try Again..Confirmation Password Mismatch!!'
    end
  end

  def presence_of_admin
    if params[:user][:role] == 'Admin' && User.find{|user| user.role == 'Admin'}.present?
      return render 'signup_page' , alert: 'Admin Already Present.'
    end
  end
end
