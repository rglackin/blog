class Users::RegistrationsController < Devise::RegistrationsController
    respond_to :json
    def configure_sign_up_params
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
  end