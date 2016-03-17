# Class comment
class TwitterConnector
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def aloof_users
    users = client.send('post',
      "/users/lookup.json?user_id=#{aloof_users_ids.join(',')}")
    users.map { |user| user.slice('id', 'name', 'screen_name') }
  end

  def unfollow_users(users_ids)
    unfollowed_users = []

    users_ids.each do |user_id|
      begin
        user = client.unfriend(user_id)
        unfollowed_users << user.slice('id', 'screen_name')
      rescue
      end
    end

    unfollowed_users
  end

  private

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: TWITTER_CONF['key'],
                                         consumer_secret: TWITTER_CONF['secret'],
                                         token: user.token,
                                         secret: user.secret)
  end

  def aloof_users_ids
    friends_ids = client.friends_ids['ids']
    followers_ids = client.followers_ids['ids']
    friends_ids - followers_ids
  end
end
