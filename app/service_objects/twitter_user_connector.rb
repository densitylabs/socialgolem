# Communicates with Twitter in behalf of an app user.
class TwitterUserConnector
  attr_accessor :user, :processed_twitter_users, :unprocessed_twitter_users

  def initialize(user)
    @user = user
    @processed_twitter_users = []
    @unprocessed_twitter_users_ids = []
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

  # client.send('post'..) is recommended for fetching more than 100 users
  def fetch_users_based_on_ids(ids, opts = {})
    ids = Array.wrap(ids)
    return if ids.blank?
    opts[:identifier] = 'user_id' unless opts[:identifier]

    users = client.send(
      'post', "/users/lookup.json?#{opts[:identifier]}=#{ids.join(',')}")
    return [] if users.is_a?(Hash) && users['errors']

    users.map do |user|
      user.slice('id', 'name', 'screen_name', 'friends_count',
                 'followers_count', 'profile_image_url', 'statuses_count')
    end
  end

  def followers_info_for(user_id)
    fetch_users_based_on_ids followers_ids_for(user_id)
  end

  def friends_info_for(user_id)
    fetch_users_based_on_ids friends_ids_for(user_id)
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

  def friends_ids_for(user_id)
    client.send('get', "/friends/ids.json?screen_name=#{user_id}")['ids']
  end

  def unfriendly_users_ids
    client.friends_ids['ids'] - client.followers_ids['ids']
  end

  def users_im_unfriendly_with_ids
    client.followers_ids['ids'] - client.friends_ids['ids']
  end
end
