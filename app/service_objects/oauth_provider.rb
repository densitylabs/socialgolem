class OauthProvider
  def request_token
    client.request_token(oauth_callback: TWITTER_CONF['callback_url'])
  end

  def authorize_and_create_user(request_token, oauth_verifier)
    binding.pry
    auth_token = client.authorize(request_token.token,
                                  request_token.secret,
                                  oauth_verifier: oauth_verifier)
    create_user(auth_token)
  end

  private

  def create_user(auth_token)
    user_info = client.info
    user = User.find_or_initialize_by(screen_name: user_info['screen_name'])
    user.update_attributes!(name: user_info['name'],
                            token: auth_token.token,
                            secret: auth_token.secret)
    user
  end

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: TWITTER_CONF['key'],
                                         consumer_secret: TWITTER_CONF['secret'])
  end
end
