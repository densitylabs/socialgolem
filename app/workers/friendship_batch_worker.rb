class FriendshipBatchWorker
  include Sidekiq::Worker

  def perform(activity_id, user_id)
    activity  = Activities::FriendshipBatchChange.find(activity_id)
    connector = TwitterUserConnector.new(User.find(user_id))

    connector.change_friendship_status_for(activity.twitter_users_ids,
                                           activity.friendship_status)
    activity.update_attributes(
      processed_twitter_users_ids: connector.processed_twitter_users,
      unprocessed_twitter_users_ids: connector.unprocessed_twitter_users,
      status: 'completed')
  end
end
