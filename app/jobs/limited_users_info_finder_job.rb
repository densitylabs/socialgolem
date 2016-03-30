class LimitedUsersInfoFinderJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :relation,
                :twitter_users_ids

  def perform(opts)
    @authenticated_user_id = opts[:authenticated_user_id]
    @twitter_user_id = opts[:twitter_user_id]
    @relation = opts[:relation]
    @twitter_users_ids = opts[:twitter_users_ids]

    associate_users(persist_users)
    broadcast_users
  end

  private

  def user_id
    @user_id ||= TwitterUser.find_by(screen_name: twitter_user_id).id
  end

  def associate_users(related_users)
    if relation == 'friends'
      TwitterUserRelation.create(
        related_users.map { |related_user| relation_hash(user_id, related_user.id) })
    else # followers
      TwitterUserRelation.create(
        related_users.map { |related_user| relation_hash(related_user.id, user_id) })
    end
  end

  def relation_hash(follower_id, friend_id)
    { from_id: follower_id, to_id: friend_id }
  end

  def persist_users
    verified_on = Time.current

    TwitterUser.create(users.map do |user|
      { twitter_id: user['id'],
        name: user['name'],
        screen_name: user['screen_name'],
        friends_count: user['friends_count'],
        followers_count: user['followers_count'],
        tweet_count: user['statuses_count'],
        profile_image_url: user['profile_image_url'],
        verified_on: verified_on }
    end)
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
