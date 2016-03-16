class OauthProvider
  attr_reader :twitter_conf

  def initialize(twitter_conf)
    @twitter_conf = twitter_conf
  end

  def request_token
    request_token = client.request_token(
      oauth_callback: twitter_conf['callback_url'])
  end

  def authorize(request_token, oauth_verifier)
    client.authorize(request_token.token,
                     request_token.secret,
                     oauth_verifier: oauth_verifier)
  end

  def save_user_data_to(user)
    client.get('/account/verify_credentials.json')
    user.update_attributes()
  end

  get('/account/verify_credentials.json')

  private

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: twitter_conf['key'],
                                         consumer_secret: twitter_conf['secret'])
  end

  def self.create_user_based_on_access_token(oauth_token, oauth_verifier)
  end
end
