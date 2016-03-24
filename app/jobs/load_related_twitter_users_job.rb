class LoadRelatedTwitterUsersJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :type_of_users_to_find

  # Example: perform(123, foo_bar, 'followers')
  def perform(authenticated_user_id, twitter_user_id, type_of_users_to_find)
    @authenticated_user_id = authenticated_user_id
    @twitter_user_id = twitter_user_id
    @type_of_users_to_find = type_of_users_to_find

    ActionCable.server.broadcast 'twitter_user_info',
                                  users: make_users_images_fullsize(find_users)
  end

  private

  def make_users_images_fullsize(users)
    users.each { |user| user['profile_image_url'].sub!('_normal', '') }
  end

  def find_users
    if type_of_users_to_find == 'friends'
      connector.friends_info_for(twitter_user_id)
    else
      connector.followers_info_for(twitter_user_id)
    end
  end

  def connector
    @connector ||= TwitterUserConnector.new(User.find(authenticated_user_id))
  end
end
