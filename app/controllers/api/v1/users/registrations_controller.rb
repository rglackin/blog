module Api
  module V1
      module Users
        class RegistrationsController < Devise::RegistrationsController
          respond_to :json
          skip_before_action :verify_authenticity_token
          before_action :configure_sign_up_params, only: [:create]
          def configure_sign_up_params
              devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
          end
          def sign_up_params
            params.require(:user).permit(:name, :email, :password, :password_confirmation)
          end
          def create
            
            puts "Params: #{params.inspect}\n\n"
            user = User.new(sign_up_params)
            if user.save
              puts "\n-------------\nUser saved\n-----------------\n"
              puts user.inspect
            end
            respond_with(user)
            #super
          end
          private
      
          def respond_with(resource, _opts = {})
            if resource.persisted?
              @token = request.env['warden-jwt_auth.token']
              headers['Authorization'] = @token
              puts "\n-------------\nToken set to:\n#{@token}\n-----------------\n"
              render json: {
                status: { code: 200, message: 'Signed up successfully.',
                token: @token,
                data: UserSerializer.new(resource).serializable_hash[:data][:attributes] }
              }
            else
              render json: {
                status: { message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}" }
                }, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
