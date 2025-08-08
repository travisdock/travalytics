class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    # Temporarily disable signups
    redirect_to root_path, alert: "Sorry, new user registration is temporarily disabled. Please check back later."
  end

  def create
    # Temporarily disable signups
    redirect_to root_path, alert: "Sorry, new user registration is temporarily disabled. Please check back later."
  end

  private
    def user_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end
end
