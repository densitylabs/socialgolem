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
    create_twitter_user_record(user_info)

    User.find_or_create_user_with(
      { screen_name: user_info['screen_name'],
        twitter_id: user_info['id'] },
      user_info.slice('name', 'token', 'secret'))
  end

  def create_twitter_user_record(twitter_user_info)
    TwitterUser.create(
      twitter_id: twitter_user_info['id'],
      name: twitter_user_info['name'],
      screen_name: twitter_user_info['screen_name'],
      friends_count: twitter_user_info['friends_count'],
      followers_count: twitter_user_info['followers_count'],
      statuses_count: twitter_user_info['statuses_count'],
      profile_image_url: twitter_user_info['profile_image_url'],
      verified_on: Time.current)
  end
end
