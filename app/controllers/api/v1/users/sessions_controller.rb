module Api
module V1
module Users
class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  before_action :set_default_response_format
  def log_in

    user= User.find_by(email: auth_params[:email])
    
    if user&.valid_password?(auth_params[:password])
      
      set_user_token!(user)
      
      respond_with(user)
    else
      render json:{message: I18n.t("devise.failure.invalid", authentication_keys: "email")}
    end
  end
  
  def destroy
    super
  end
  private

  def auth_params
    params.require(:user).permit(:email, :password)
  end

  def set_default_response_format
    request.format = :json
  end
  def set_user_token!(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    request.env['warden-jwt_auth.token'] = token
    headers['Authorization'] = "Bearer #{token}"
  end

  def respond_with(resource, _opt = {})
    if request.format.json?
      @token = request.env['warden-jwt_auth.token']
      headers['Authorization'] = @token
      render json: {
        status: {
          code: 200, message: 'Logged in successfully.',
          token: @token,
          data: {
            user: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }
        }
      }, status: :ok
    else
      super
    end
  end
  
  def respond_to_on_destroy
    
    if request.format.json?
      if request.headers['Authorization'].present?
        
        jwt_payload = JWT.decode(request.headers['Authorization'].split.last, Rails.application.credentials.devise_jwt_secret_key!).first
        
        user = User.find(jwt_payload['sub'])
      end
  
      if user
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Couldn't find an active session."
        }, status: :unauthorized
      end  
    else
      
      super
    end
    
  end
end
end
end
end