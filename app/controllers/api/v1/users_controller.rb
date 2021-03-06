module Api
  module V1
    class UsersController < ApplicationController
      def create
        user_input_username = user_params[:username]
        user_input_password = user_params[:password]
        # If user !exists then resgister and add to session
        if !User.exists?(username: user_input_username)
          user = User.new(user_params);
          if user.save
            render json: {status:'SUCCESS', message:'User added', data:user},status: :created
            reset_session
            session[:user] = user.username
          else
            render json: {status:'ERROR', message:'User could not be added',
            data:user.errors},status: :unprocessable_entity
          end
        # If use exists check credentials and login/set session
        else
          user =  User.find_by(username: user_input_username)
          hash_password = user.password
          decrypt_password = BCrypt::Password.new(hash_password)

          if decrypt_password == user_input_password
            reset_session
            session[:user] = user_input_username
            render json: {status:'SUCCESS', message:'Login successful', data:user},status: :ok
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
