# Communicates with Twitter in behalf of an app user.
class TwitterUserConnector
  attr_accessor :user

  def initialize(user)
    @user = user
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

  def follow_users(ids)
    change_friendship_status_for(ids, :friend)
  end

  private

  def change_friendship_status_for(ids, status)
    users = []

    ids.each do |id|
      begin
        user = client.send(status, id)
        users << user.slice('id', 'screen_name')
      rescue
      end
    end

    users
  end

  def fetch_users_based_on_ids(ids)
    # post supports fetching more than 100 users
    users = client.send('post', "/users/lookup.json?user_id=#{ids.join(',')}")

    return [] if users.is_a?(Hash) && users['errors']
    users.map { |user| user.slice('id', 'name', 'screen_name') }
  end

  def client
    @client ||= TwitterOAuth::Client.new(consumer_key: TWITTER_CONF['key'],
                                         consumer_secret: TWITTER_CONF['secret'],
                                         token: user.token,
                                         secret: user.secret)
  end

  def unfriendly_users_ids
    client.friends_ids['ids'] - client.followers_ids['ids']
  end

  def users_im_unfriendly_with_ids
    client.followers_ids['ids'] - client.friends_ids['ids']
  end
end
