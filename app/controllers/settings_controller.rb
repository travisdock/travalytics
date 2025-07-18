class SettingsController < ApplicationController
  before_action :require_authentication

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to edit_settings_path, notice: "Settings updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    @user = current_user

    if @user.authenticate(params[:current_password])
      if @user.update(password_params)
        # Invalidate all other sessions for security
        @user.sessions.where.not(id: Current.session.id).destroy_all
        redirect_to edit_settings_path, notice: "Password updated successfully"
      else
        @user.errors.add(:password, @user.errors.full_messages_for(:password).join(", "))
        render :edit, status: :unprocessable_entity
      end
    else
      @user.errors.add(:current_password, "is incorrect")
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:time_zone)
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
