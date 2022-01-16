module Api
  module V1
    class UsersController < ApplicationController
      def index
        users = User.order('created_at DESC');
        render json: {status:'SUCCESS', message:'Loaded users', data:users},status: :ok
      end

      def create
        user_input_username = user_params[:username]
        user_input_password = user_params[:password]
        # If user !exists then resgister and add to session
        if !User.exists?(username: user_input_username)
          user = User.new(user_params);
          if user.save
            render json: {status:'SUCCESS', message:'User added'},status: :ok
            session[:user] = user.username
          else
            render json: {status:'ERROR', message:'User could not be added',
            data:user.errors},status: :unprocessable_entity
          end
        # If use exists check credentials and login/set session
        else
          hash_password = User.find_by(username: user_input_username).password
          decrypt_password = BCrypt::Password.new(hash_password)

          if decrypt_password == user_input_password
            session[:user] = user_input_username
            render json: {status:'SUCCESS', message:'Login successful'},status: :ok
          else
            render json: {status:'ERROR', message:'Could not log in'},status: :unauthorized
          end
        end
      end

      private

      def user_params
        params.require(:user).permit(:username, :password)
      end
    end
  end
end
