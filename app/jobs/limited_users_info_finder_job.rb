class LimitedUsersInfoFinderJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :relation,
                :twitter_users_ids

  def perform(opts)
    @authenticated_user_id = opts[:authenticated_user_id]
    @twitter_user_id = opts[:twitter_user_id]
    @relation = opts[:relation]
    @twitter_users_ids = opts[:twitter_users_ids]

    broadcast_message
    # also save those users info to the DB
  end

  private

  def channel_id
    "twitter_user_info_#{authenticated_user_id}_" \
      "#{twitter_user_id}_#{relation}"
  end

  def broadcast_message(message)
    ActionCable.server.broadcast(
      channel_id,
      users: connector.fetch_users_based_on_ids(twitter_users_ids))
  end

  def connector
    @connector ||= TwitterUserConnector.new(User.find(authenticated_user_id))
  end
end
