module Api
  module V1
    class TweetsController < ApplicationController

      def index
        user_tweets = Tweet.where(username: session[:user]).order("created_at DESC")

        if !user_tweets.blank?
          render json: {status:'SUCCESS', message:'Tweets retrieved', data:user_tweets},status: :ok
        else
          render json: {status:'SUCCESS', message:'No tweets to show'},status: :ok
        end
      end

      def create
        params_description = tweet_params[:description]
        if !params_description.blank? && !params_description.nil?
          new_tweet = Tweet.new(username: session[:user], description: params_description , like: "", retweet: "");

          if new_tweet.save
            render json: {status:'SUCCESS', message:'Tweet sent', data:new_tweet},status: :created
          else
            render json: {status:'ERROR', message:'Tweet could not be sent', data:new_tweet.errors},status: :unprocessable_entity
          end
        else
          render json: {status:'ERROR', message:'Tweet cannot be blank'},status: :unprocessable_entity
        end
      end

      def update
        user_tweet = Tweet.find(params[:id])
        if user_tweet.username == session[:user]
          user_tweet.description = tweet_params[:description]
          user_tweet.save
          render json: {status:'SUCCESS', message:'Tweet updated', data:user_tweet},status: :ok
        else
          render json: {status:'ERROR', message:'You do not have permission'},status: :unauthorized
        end
      end
      
      def destroy
        user_tweet = Tweet.find(params[:id])
        if user_tweet.username == session[:user]
          user_tweet.delete
          render json: {status:'SUCCESS', message:'Tweet deleted', data:user_tweet},status: :ok
        else
          render json: {status:'ERROR', message:'You do not have permission'},status: :unauthorized
        end

      end

      private

      def tweet_params
        params.require(:tweet).permit(:description, :like, :retweet, :id)
      end
    end
  end
end
