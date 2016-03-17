class OauthController < ApplicationController
  def callback
    oauth_provider = OauthProvider.new
    user = oauth_provider.authorize_and_create_user(session[:request_token],
                                                    params[:oauth_verifier])
    session[:user_id] = user.id

    redirect_to home_aloof_users_path
  end
end
