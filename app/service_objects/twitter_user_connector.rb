# Communicates with Twitter in behalf of an app user.
class TwitterUserConnector
  attr_accessor :user, :processed_twitter_users, :unprocessed_twitter_users

  def initialize(user)
    @user = user
    @processed_twitter_users = []
    @unprocessed_twitter_users_ids = []
  end

  def screen_name
    @user.screen_name
  end

  def unfriendly_users
    fetch_users_based_on_ids(unfriendly_users_ids)
  end

  def unfollow_users(ids)
    change_friendship_status_for(ids, :unfriend)
  end

  def users_im_unfriendly_with
    fetch_users_based_on_ids(users_im_unfriendly_with_ids)
  end

  def change_friendship_status_for(ids, friendship_status)
    ids.each do |id|
      begin
        twitter_user = client.send(friendship_status, id)
        processed_twitter_users << twitter_user['screen_name']
      rescue
      end
    end
  end

  def fetch_users_based_on_ids(ids, opts = {})
    ids = Array.wrap(ids)
    return if ids.blank?
    opts[:identifier] = 'user_id' unless opts[:identifier]

    users = client.send(
      'post', "/users/lookup.json?#{opts[:identifier]}=#{ids.join(',')}")

    return [] if users.is_a?(Hash) && users['errors']

    users = users.map do |user|
      user.slice('id', 'name', 'screen_name', 'friends_count',
                 'followers_count', 'profile_image_url', 'statuses_count')
    end

    users.each { |user| user['profile_image_url'].sub!('_normal', '') }
  end

  def id_of_users_in_relation_with(user_id, relation)
    if relation == 'friends'
      friend_ids_for(user_id)
    else
      followers_ids_for(user_id)
    end
  end

  def friend(twitter_id)
    client.friend(twitter_id)
    user.add_friend(TwitterUser.find_by(twitter_id: twitter_id))
  end

  def friend_ids_for(user_id)
    client.send('get', "/friends/ids.json?screen_name=#{user_id}")['ids']
  end

  private

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: TWITTER_CONF['key'],
                                         consumer_secret: TWITTER_CONF['secret'],
                                         token: user.token,
                                         secret: user.secret)
  end

  def followers_ids_for(user_id)
    client.send('get', "/followers/ids.json?screen_name=#{user_id}")['ids']
  end

  def unfriendly_users_ids
    client.friends_ids['ids'] - client.followers_ids['ids']
  end

  def users_im_unfriendly_with_ids
    client.followers_ids['ids'] - client.friends_ids['ids']
  end
end
