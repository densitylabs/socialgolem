class TwitterUserRelation < ActiveRecord::Base
  belongs_to :friend, class_name: 'TwitterUser', foreign_key: :follower_id,
                      required: true
  belongs_to :follower, class_name: 'TwitterUser', foreign_key: :friend_id,
                        required: true
end
