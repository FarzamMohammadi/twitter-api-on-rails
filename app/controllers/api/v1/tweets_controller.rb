module Api
  module V1
    class TweetsController < ApplicationController
      def index
        user_tweets = Tweet.where(username: session[:user]).order("created_at")

        if !user_tweets.blank?
          render json: {status:'SUCCESS', message:'Tweets retrieved', data:user_tweets},status: :ok
        else
          render json: {status:'SUCCESS', message:'No tweets to show'},status: :ok
        end

      end
      def create

      end
      def edit

      end
      def destroy

      end

      private

      def chat_params
        params.require(:tweet).permit(:receiver, :message, :sender)
      end
    end
  end
end
