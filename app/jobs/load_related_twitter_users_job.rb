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
    # request only for the ids you don't know
    # find how many requests will be done
    # find what total represents the users that will be sent back to the frontend

    ids.in_groups_of(100, false) do |group_of_ids|
      LimitedUsersInfoFinderJob.perform_later(
        authenticated_user_id: authenticated_user_id,
        twitter_user_id: twitter_user_id,
        relation: relation,
        twitter_users_ids: group_of_ids)
    end
  end

  def connector
    @connector ||= TwitterUserConnector.new(User.find(authenticated_user_id))
  end
end
