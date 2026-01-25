class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Share data with Inertia pages
  inertia_share do
    {
      currentUser: current_user ? {
        id: current_user.id,
        email: current_user.email_address,
        timeZone: current_user.time_zone
      } : nil,
      signedIn: signed_in?,
      flash: {
        notice: flash[:notice],
        alert: flash[:alert]
      },
      csrfToken: form_authenticity_token
    }
  end
end
