class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :require_authentication

  private

  def require_authentication
    unless session[:user_id] || params[:oauth_verifier]
      reset_session
      enroller = TwitterUserEnroller.new
      session[:request_token] = enroller.request_token

      redirect_to session[:request_token].authorize_url
    end
  end
end
