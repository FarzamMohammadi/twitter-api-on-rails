module Api
  module V1
    class ChatsController < ApplicationController
      def create
        new_chat = Chat.new(sender: session[:user], receiver: chat_params[:receiver] , message: chat_params[:message], read: false);
        if new_chat.save
          render json: {status:'SUCCESS', message:'Message sent', data:new_chat},status: :ok
        else
          render json: {status:'ERROR', message:'Message could not be added',
          data:new_chat.errors},status: :unprocessable_entity
        end
      end

      private

      def chat_params
        params.require(:chat).permit(:receiver, :message)
      end
    end
  end
end
