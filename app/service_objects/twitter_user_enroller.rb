# Provides functionality to enroll an authenticated user.
class TwitterUserEnroller
  attr_reader :twitter_conf

  def initialize(twitter_conf)
    @twitter_conf = twitter_conf
  end

  def request_token
    client.request_token(oauth_callback: twitter_conf['callback_url'])
  end

  # authorizes the user in Twitter and returns her information
  def authorize_user(request_token, oauth_verifier)
    access_token = client.authorize(request_token.token,
                                    request_token.secret,
                                    oauth_verifier: oauth_verifier)

    # hash rocket syntax for consistency with the info
    client.info.merge('token' => request_token.token,
                      'secret' => request_token.secret)
  end

  private

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: twitter_conf['key'],
                                         consumer_secret: twitter_conf['secret'])
  end
end
