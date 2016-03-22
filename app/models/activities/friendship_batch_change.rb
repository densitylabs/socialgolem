module Activities
  class FriendshipBatchChange < ActiveRecord::Base
    serialize :twitter_users_ids, Array
    serialize :processed_twitter_users_ids, Array
    serialize :unprocessed_twitter_users_ids, Array
  end
end
