class FindTwitterUsersJob < ActiveJob::Base
  queue_as :default

  attr_accessor :user_screen_name

  def perform(user_screen_name, user_ids, channel_id)
    @user_screen_name = user_screen_name
    users = connector.fetch_users_based_on_ids(user_ids)

    users.each { |user| persist_user(user) }
    ActionCable.server.broadcast(channel_id, users: users)
  end

  private

  def persist_user(user)
    verified_on = Time.current
    user_record = TwitterUser.find_or_initialize_by(twitter_id: user['id'])

    user_record.update_attributes(twitter_id: user['id'],
                                  name: user['name'],
                                  screen_name: user['screen_name'],
                                  friends_count: user['friends_count'],
                                  followers_count: user['followers_count'],
                                  statuses_count: user['statuses_count'],
                                  profile_image_url: user['profile_image_url'],
                                  verified_on: verified_on)
  end

  def connector
    @connector ||= TwitterUserConnector.new(
      User.find_by(screen_name: user_screen_name))
  end
end
