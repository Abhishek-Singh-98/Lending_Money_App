class WalletsController < ApplicationController
  before_action :check_login_user

  def show
    @wallet = @user.wallet
  end

  def edit
    
  end

  def update
    @wallet = @user.wallet
    if @wallet.update(amount: @wallet.amount + wallet_params[:amount].to_f)
      redirect_to user_wallet_path(user_id: @user.id, id: @wallet.id), notice: 'Money added successfully.'
    else
      redirect_to user_wallet_path(user_id: @user.id, id: @wallet.id),alert: 'Failed to add money.'
    end
  end

  private
  def wallet_params
    params.permit(:amount)
  end
end
