module Api
  module V1
    class ChatsController < ApplicationController
      def index
        # Renders unread messages
        chat_to_show = Chat.where(receiver: session[:user], sender: chat_params[:sender], read: false)
        messages_to_show = chat_to_show.pluck(:message)

        if !chat_to_show.blank?
          render json: {status:'SUCCESS', message:'Messages retrieved', data:messages_to_show},status: :ok
          # Saves messages as read after rendering
          chat_to_show.each do |c|
            c.read = true
            c.save
          end
        else
          render json: {status:'SUCCESS', message:'You have no messages'},status: :ok
        end
      end
      
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
          render json: {status:'ERROR', message:'Receiver profile does not exist'},status: :bad_request
        end
      end

      private

      def chat_params
        params.require(:chat).permit(:receiver, :message, :sender)
      end
    end
  end
end
