module Api
module V1
module Users
class SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  private

  def respond_with(resource, _opt = {})
    puts "api session controller"
    puts "------\nJson request?: #{request.format.json?}\n-------"
    if request.format.json?
      @token = request.env['warden-jwt_auth.token']
      puts "\nEnv token\n#{@token}\n------\n"
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
        current_user = User.find(jwt_payload['sub'])
      end
  
      if current_user
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