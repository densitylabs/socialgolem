class OauthController < ApplicationController
  def callback
    enroller = TwitterUserEnroller.new(TWITTER_CONF)
    user_info = enroller.authorize_user(session[:request_token],
                                        params[:oauth_verifier])

    cookies.signed[:user_id] = persist_user(user_info).id
    session[:request_token] = nil

    redirect_to root_path
  end

  private

  def persist_user(user_info)
    User.find_or_create_user_with({ screen_name: user_info['screen_name'] },
                                    user_info.slice('name', 'token', 'secret'))
  end
end
