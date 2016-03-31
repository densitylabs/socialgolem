# Job that broadcasts information about related users (followings or followers)
# of a user.
class LoadRelatedTwitterUsersJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :relation

  # perform(123, 'foo_bar', 'followers')
  def perform(authenticated_user_id, twitter_user_id, relation)
    @authenticated_user_id = authenticated_user_id
    @twitter_user_id = twitter_user_id
    @relation = relation

    associate_existent_users
    broadcast_initial_data
    delegate_fetch_of_users_info
  end

  private

  def broadcast_initial_data
    ActionCable.server.broadcast(
      channel_id,
      initial_message: 'true',
      users_total: twitter_users_ids.count,
      available_local_total: valid_local_users.count,
      users: valid_local_users[0..50],
      authenticated_user_friends_ids: authenticated_user_friends_ids)
  end

  def delegate_fetch_of_users_info
    twitter_users_ids_to_fetch.in_groups_of(100, false) do |group_of_ids|
      LimitedUsersInfoFinderJob.perform_later(
        authenticated_user_id: authenticated_user_id,
        twitter_user_id: twitter_user_id,
        relation: relation,
        twitter_users_ids: group_of_ids)
    end
  end

  def authenticated_user_friends_ids
    connector.friends_ids_for(authenticated_user.screen_name)
  end

  def twitter_users_ids_to_fetch
    return [] if visited_twitter_user.verified_on >= 1.day.ago

    twitter_users_ids - valid_local_users.pluck(:twitter_id)
  end

  def valid_local_users
    TwitterUser.where(twitter_id: twitter_users_ids)
               .where('verified_on >= ?', 1.day.ago)
  end

  def associate_existent_users
    user_id = TwitterUser.find_by(screen_name: twitter_user_id).id

    if relation == 'friends'
      TwitterUserRelation.create(
        (valid_local_users.pluck(:id) - visited_twitter_user.friends.pluck(:id)).map do |friend_id|
          { from_id: user_id, to_id: friend_id }
        end
      )
    else # followers
      TwitterUserRelation.create(
        (valid_local_users.pluck(:id) - visited_twitter_user.followers.pluck(:id)).map do |follower_id|
          { from_id: follower_id, to_id: user_id }
        end
      )
    end
  end

  def twitter_users_ids
    @twitter_users_ids ||= connector.ids_of_users_in_relation_with(
      twitter_user_id, relation)
  end

  def connector
    @connector ||= TwitterUserConnector.new(authenticated_user)
  end

  def authenticated_user
    User.find(authenticated_user_id)
  end

  def visited_twitter_user
    TwitterUser.find_by(screen_name: twitter_user_id)
  end

  def channel_id
    "twitter_user_info_#{authenticated_user_id}_#{twitter_user_id}_#{relation}"
  end
end
