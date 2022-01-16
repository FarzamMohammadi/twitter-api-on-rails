module Api
  module V1
    class ChatsController < ApplicationController
      def create
        # Checks to see if receiver exists in DB - not necessary - thought it would make api more practical
        exists = User.find_by(username: chat_params[:receiver])
        if !exists.nil?
          new_chat = Chat.new(sender: session[:user], receiver: chat_params[:receiver] , message: chat_params[:message], read: false);
          if new_chat.save
            render json: {status:'SUCCESS', message:'Message sent', data:new_chat},status: :ok
          else
            render json: {status:'ERROR', message:'Message could not be added',
            data:new_chat.errors},status: :unprocessable_entity
          end
        else
          render json: {status:'ERROR', message:'Receiver does not exist'},status: :bad_request
        end
      end

      private

      def chat_params
        params.require(:chat).permit(:receiver, :message)
      end
    end
  end
end
