class ApplicationController < ActionController::API
	before_action :authorize_request, except: [:create]


	private
	
	def authorize_request
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
