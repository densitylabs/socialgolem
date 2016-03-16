class HomeController < ApplicationController
  def index
    oauth_provider = OauthProvider.new(TWITTER_CONF)
    session[:request_token] = oauth_provider.request_token
    redirect_to session[:request_token].authorize_url
  end
end
