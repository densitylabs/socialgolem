class TwitterUser < ActiveRecord::Base
  has_many :friends, class_name: 'TwitterUserRelation', foreign_key: :follower_id
  has_many :followers, class_name: 'TwitterUserRelation', foreign_key: :friend_id
end
