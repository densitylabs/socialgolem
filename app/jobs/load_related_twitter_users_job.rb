class LoadRelatedTwitterUsersJob < ActiveJob::Base
  queue_as :default

  attr_accessor :authenticated_user_id, :twitter_user_id, :type_of_users_to_find

  # Example: perform(123, foo_bar, 'followers')
  def perform(authenticated_user_id, twitter_user_id, type_of_users_to_find)
    @authenticated_user_id = authenticated_user_id
    @twitter_user_id = twitter_user_id
    @type_of_users_to_find = type_of_users_to_find

    channel_id = "twitter_user_info_#{authenticated_user_id}_" \
      "#{twitter_user_id}_#{type_of_users_to_find}"

    ActionCable.server.broadcast channel_id, users: make_users_images_fullsize(find_users)
    # ActionCable.server.broadcast 'twitter_user_info', users: the_users
  end

  private

  # def the_users
  #   [{"id"=>12022522,
  #     "name"=>"Hector Perez",
  #     "screen_name"=>"arpahector",
  #     "friends_count"=>757,
  #     "followers_count"=>848,
  #     "profile_image_url"=>"http://pbs.twimg.com/profile_images/422059642152173568/CQ73y90m.jpeg"}]
  # end

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
