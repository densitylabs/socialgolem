class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_authentication

  def index
  end

  private

  def require_authentication
    unless session[:user_id]
      oauth_provider = TwitterUserEnroller.new
      request_token = oauth_provider.request_token
      session[:request_token] = request_token

      redirect_to session[:request_token].authorize_url
    end
  end
end
