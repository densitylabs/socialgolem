class LimitedUsersInfoFinderJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :relation,
                :twitter_users_ids

  def perform(opts)
    @authenticated_user_id = opts[:authenticated_user_id]
    @twitter_user_id = opts[:twitter_user_id]
    @relation = opts[:relation]
    @twitter_users_ids = opts[:twitter_users_ids]

    persist_users
    broadcast_users
  end

  private

  def persist_users
    TwitterUser.create(
      users.map do |user|
        { twitter_id: user['id'],
          screen_name: user['name'],
          friends_count: user['friends_count'],
          followers_count: user['followers_count'],
          tweet_count: user['statuses_count'],
          profile_image_url: user['profile_image_url'] }
      end
    )
  end

  def broadcast_users
    ActionCable.server.broadcast(channel_id, users: users)
  end

  def users
    @users ||= connector.fetch_users_based_on_ids(twitter_users_ids)
  end

  def channel_id
    "twitter_user_info_#{authenticated_user_id}_#{twitter_user_id}_#{relation}"
  end

  def connector
    @connector ||= TwitterUserConnector.new(User.find(authenticated_user_id))
  end
end
