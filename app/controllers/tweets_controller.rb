class TweetsController < ApplicationController
before_action :authenticate_user, only: %i[create destroy]

def create
tweet = @current_user.tweets.build(tweet_params)

if tweet.save
  render json: {
    tweet: {
      username: tweet.user.username,
      message: tweet.message
    }
  }, status: :created
else
  render json: { errors: tweet.errors.full_messages }, status: :unprocessable_entity
end
end

def destroy
tweet = @current_user.tweets.find_by(id: params[:id])

if tweet
  tweet.destroy
  render json: { success: true }
else
  render json: { success: false, error: 'Tweet not found' }, status: :not_found
end
end

def index
tweets = Tweet.order(created_at: :desc)

render json: {
  tweets: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } }
}
end

def index_by_user
user = User.find_by(username: params[:username])

if user
  tweets = user.tweets

  render json: {
    tweets: tweets.map { |tweet| { id: tweet.id, username: tweet.user.username, message: tweet.message } }
  }
else
  render json: { error: 'User not found' }, status: :not_found
end
end

private

def tweet_params
params.require(:tweet).permit(:message)
end

def authenticate_user
session = Session.find_by(token: cookies.signed['twitter_session_token'])

if session
  @current_user = session.user
else
  render json: { success: false }, status: :unauthorized
end
end
end