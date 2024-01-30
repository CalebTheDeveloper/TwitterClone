class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:user][:username])

    if user && (BCrypt::Password.new(user.password) == params[:user][:password])
      session = user.sessions.create

      cookies.signed[:twitter_session_token] = session.token

      render json: { success: true }, status: :created
    else
      render json: { error: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def authenticated
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session
      render json: { authenticated: true, username: session.user.username }
    else
      render json: { authenticated: false }
    end
  end

  def destroy
    session = Session.find_by(token: cookies.signed[:twitter_session_token])

    if session
      session.destroy
      cookies.delete(:twitter_session_token)

      render json: { success: 'Logged out successfully' }
    else
      render json: { error: 'Session not found' }, status: :not_found
    end
  end
end
