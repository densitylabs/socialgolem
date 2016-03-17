class HomeController < ApplicationController
  def index
  end

  def aloof_users
    @users = oauth_provider.aloof_users
  end

  def unfollow_users
    @users = oauth_provider.unfollow_users(params[:users_ids].split(','))
  end

  private

  def oauth_provider
    @oauth_provider ||= TwitterUserConnector.new(User.find(session[:user_id]))
  end
end
