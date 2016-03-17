class HomeController < ApplicationController
  def index
    oauth_provider = OauthProvider.new
    session[:request_token] = oauth_provider.request_token
    redirect_to session[:request_token].authorize_url
  end

  def aloof_users
    @aloof_users = oauth_provider.aloof_users
  end

  def unfollow_users(users_ids)
    render json: oauth_provider.unfollow_users(users_ids)
  end

  private

  def oauth_provider
    @oauth_provider ||= TwitterConnector.new(User.find(session[:user_id]))
  end
end
