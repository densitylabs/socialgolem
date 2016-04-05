# Job that broadcasts information about related users (followings or followers)
# of a user.
class FindRelatedTwitterUsersJob < ActiveJob::Base
  queue_as :default

  attr_accessor :current_user_screen_name, :visited_user_screen_name,
                :relation, :channel_id

  # ex. perform('foo', 'bar', 'friends')
  def perform(current_user_screen_name, visited_user_screen_name, relation)
    @current_user_screen_name = current_user_screen_name
    @visited_user_screen_name = visited_user_screen_name
    @relation = relation
    @channel_id = "twitter_user_info_#{current_user_screen_name}_"\
                  "#{visited_user_screen_name}_#{relation}"

    find_and_broadcast_data
  end

  private

  def find_and_broadcast_data
    current_user_ids = find_and_link_related_ids_of(current_user, 'friends')
    related_user_ids = find_and_link_related_ids_of(visited_user, relation)

    remote_ids = related_user_ids - local_users(related_user_ids).pluck(:twitter_id)

    broadcast_data(related_user_count: related_user_ids.count,
                   first_user_batch: local_users(related_user_ids).limit(51),
                   local_user_count: local_users(related_user_ids).count,
                   current_user_ids: current_user_ids)

    delegate_user_fetch(remote_ids)
  end

  def broadcast_data(opts)
    ActionCable.server.broadcast(
      channel_id,
      is_base_message: true,
      related_user_count: opts[:related_user_count],
      users: opts[:first_user_batch],
      local_user_count: opts[:local_user_count],
      current_user_ids: opts[:current_user_ids])
  end

  def delegate_user_fetch(remote_ids)
    return if remote_ids.blank?

    remote_ids.in_groups_of(100, false) do |user_ids|
      FindTwitterUsersJob.new.perform(
        current_user_screen_name, user_ids, channel_id)
    end
  end

  def find_and_link_related_ids_of(user, relation)
    ids = connector.id_of_users_in_relation_with(user.screen_name, relation)
    user.link_related_user_ids(ids, relation)

    ids
  end

  def local_users(ids)
    TwitterUser.where(twitter_id: ids)
               .where('verified_on >= ?', 1.day.ago)
  end

  def connector
    @connector ||= TwitterUserConnector.new(current_user.user)
  end

  def current_user
    TwitterUser.find_by(screen_name: current_user_screen_name)
  end

  def visited_user
    TwitterUser.find_by(screen_name: visited_user_screen_name)
  end
end
