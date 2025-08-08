class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    # Temporarily disable signups
    redirect_to root_path, alert: "Sorry, new user registration is temporarily disabled. Please check back later."
  end

  def create
    # @user = User.new(user_params)

    # if @user.save
    #   start_new_session_for @user
    #   redirect_to after_authentication_url, notice: "Welcome! Your account has been created."
    # else
    #   render :new, status: :unprocessable_entity
    # end

    # Temporarily disable signups
    redirect_to root_path, alert: "Sorry, new user registration is temporarily disabled. Please check back later."
  end

  private
    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end
end
