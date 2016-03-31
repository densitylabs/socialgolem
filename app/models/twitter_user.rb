# Represents a twitter user.
class TwitterUser < ActiveRecord::Base
  has_many :relations_from, class_name: 'TwitterUserRelation', foreign_key: :from_id
  has_many :friends, through: :relations_from

  has_many :relations_to, class_name: 'TwitterUserRelation', foreign_key: :to_id
  has_many :followers, through: :relations_to

  SUPPORTED_SEARCH_PATTERNS = ['statuses_count', 'friends_count', 'followers_count'].freeze

  def friends_by(pattern, page = 1, order_direction = :desc, per_page = 51)
    friends.order(pattern => order_direction)
           .limit(per_page)
           .offset(per_page * ([page.to_i, 1].max - 1))
  end

  def followers_by(pattern, page = 1, order_direction = :desc, per_page = 51)
    followers.order(pattern => order_direction)
             .limit(per_page)
             .offset(per_page * ([page.to_i, 1].max - 1))
  end
end
