module Api
  module V1
    class AuthController < ApplicationController
      before_action :authorize_request, only: [:validate_token]

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token:, user: user.slice(:id, :first_name, :last_name,:email, :role) }
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def guest
        guest_user = User.create(
          name: "Guest",
          email: "guest_#{Time.now.to_i}@test.com",
          password: "guest123",
          role: "guest"
        )
        token = encode_token({ user_id: guest_user.id })
        render json: { token:, user: guest_user.slice(:id, :name, :email, :role) }
      end

      def validate_token
        render json: {
          success: true,
            user: {
            id: @current_user.id,
            first_name: @current_user.first_name,
            last_name: @current_user.last_name,
            email: @current_user.email,
            role: @current_user.role
          }
        }
      end

      def logout
        render json: { message: "Successfully logged out" }, status: :ok
      end


      private

      def encode_token(payload)
        JWT.encode(payload, Rails.application.secret_key_base)
      end


      def authorize_request1
        header = request.headers['Authorization']
        token = JSON.parse(header.split(' ').last) if header

        begin
          decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
          @current_user = User.find(decoded["user_id"])
        rescue JWT::DecodeError
          render json: { errors: 'Invalid Token' }, status: :unauthorized
        end
      end

    end
  end
end
