# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      

      def index
        if @current_user
          service_users = User.where(role: params[:profession])
          render json: { users: service_users},status: :ok
        end

      end

      def create
        user = User.new(user_params)
        if user.save
          token = JWT.encode({ user_id: user.id }, Rails.application.secret_key_base)
          render json: { token:, user: user.slice(:id, :first_name,:last_name, :email, :role) }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

       


      private

      def user_params
        params.permit(:first_name, :last_name, :email, :password, :role, :mobile_number, :address)
      end

    end
  end
end
