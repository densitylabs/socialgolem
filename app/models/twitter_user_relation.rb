class TwitterUserRelation < ActiveRecord::Base
  belongs_to :friend, class_name: 'TwitterUser', foreign_key: :to_id,
                      required: true
  belongs_to :follower, class_name: 'TwitterUser', foreign_key: :from_id,
                        required: true
end
