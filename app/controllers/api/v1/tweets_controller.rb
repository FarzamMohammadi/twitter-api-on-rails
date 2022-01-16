module Api
  module V1
    class TweetsController < ApplicationController

      def index
        user_tweets = Tweet.where(username: session[:user]).order("created_at DESC")

        if !user_tweets.blank?
          render json: {status:'SUCCESS', message:'Tweets retrieved', data:user_tweets},status: :ok
        else
          render json: {status:'SUCCESS', message:'No tweets to show'},status: :created
        end
      end

      def create
        new_tweet = Tweet.new(username: session[:user], description: tweet_params[:description] , like: "", retweet: "");

        if new_tweet.save
          render json: {status:'SUCCESS', message:'Tweets sent', data:new_tweet},status: :ok
        else
          render json: {status:'SUCCESS', message:'Tweets could not be sent', data:new_tweet.errors},status: :ok
        end
      end
      def edit

      end
      def destroy

      end

      private

      def tweet_params
        params.require(:tweet).permit(:description, :like, :retweet)
      end
    end
  end
end
