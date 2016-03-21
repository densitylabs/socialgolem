class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :authenticated_user?

  private

  def require_authentication
    unless session[:user_id] || params[:oauth_verifier]
      reset_session
      enroller = TwitterUserEnroller.new(TWITTER_CONF)
      session[:request_token] = enroller.request_token

      redirect_to session[:request_token].authorize_url
    end
  end

  def authenticated_user?
    session[:user_id].present?
  end
end
