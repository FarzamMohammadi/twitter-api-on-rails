module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.order('created_at DESC');
        render json: {status:'SUCCESS', message:'Loaded users', data:users},status: :ok
      end

      def create
        user = User.new(user_params);

        if user.save
          render json: {status:'SUCCESS', message:'User added', data:user},status: :ok
        else
          render json: {status:'ERROR', message:'User could not be added',
          data:user.errors},status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.permit(:username, :password)
      end
    end
  end
end
