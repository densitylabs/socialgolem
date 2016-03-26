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

    broadcast_users_info
  end

  private

  def broadcast_users_info
    ids = connector.relations_ids(twitter_user_id, relation)

    ids.in_groups_of(100, false) do |group_of_ids|
      ActionCable.server.broadcast(
        channel_id,
        users: connector.fetch_users_based_on_ids(group_of_ids))
    end
  end

  def broadcast_message(message)
    ActionCable.server.broadcast(channel_id,
      users: make_users_images_fullsize(find_users))
  end

  def channel_id
    "twitter_user_info_#{authenticated_user_id}_" \
      "#{twitter_user_id}_#{relation}"
  end

  def connector
    @connector ||= TwitterUserConnector.new(User.find(authenticated_user_id))
  end
end
