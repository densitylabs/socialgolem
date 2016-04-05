class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_authentication
  helper_method :authenticated_user

  private

  def connector
    @connector ||= TwitterUserConnector.new(User.find(cookies.signed[:user_id]))
  end

  def require_authentication
    unless authenticated_user || params[:oauth_verifier]
      reset_session
      enroller = TwitterUserEnroller.new(TWITTER_CONF)
      session[:request_token] = enroller.request_token

      redirect_to session[:request_token].authorize_url
    end
  end

  def authenticated_user
    return unless cookies.signed[:user_id]

    User.find_by(id: cookies.signed[:user_id])
  end

  def current_twitter_user_path
    twitter_user_twitter_user_path(user_id: connector.screen_name,
                                   relation: 'following')
  end

  helper_method :current_twitter_user_path
end
