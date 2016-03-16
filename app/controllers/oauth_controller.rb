class OauthController < ApplicationController
  def callback
    oauth_provider = OauthProvider.new(TWITTER_CONF)
    oauth_provider.authorize(session[:request_token], params[:oauth_provider])
    session[:user_id] = oauth_provider.save_user_data_to(User.new).id
  end
end
