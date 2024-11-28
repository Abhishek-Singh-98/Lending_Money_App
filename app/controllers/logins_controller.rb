class LoginsController < ApplicationController
  before_action :authorize_user, only: [:login_user]

  def new
  end

  def login_user
    unless @user.present?
      flash[:alert] = "Invalid User Login"
      return redirect_to new_login_path
    end

    if @user&.authenticate(login_params[:password])
      @token = JwtAuthentication.encode(id: @user.id)
      session[:user_id] = @user.id
      session[:token] = @token
      redirect_to user_path(id: @user.id), notice: "Welcome #{@user.first_name}!! Enjoy Lending Money"
    else
      flash[:alert] = "Invalid Password or Email"
      redirect_to new_login_path
    end
    
  end

  private

  def login_params
    params.require(:user).permit(:email, :password, :role)
  end

  def authorize_user
    redirect_to '/login/new', alert: 'Role is missing' unless login_params[:role].present?
    @user = User.where(email: login_params[:email].downcase, role: login_params[:role])&.first
  end
end
