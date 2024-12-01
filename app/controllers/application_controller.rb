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
end
