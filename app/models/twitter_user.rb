# Represents a twitter user.
class TwitterUser < ActiveRecord::Base
  has_many :relations_from, class_name: 'TwitterUserRelation', foreign_key: :from_id
  has_many :friends, through: :relations_from

  has_many :relations_to, class_name: 'TwitterUserRelation', foreign_key: :to_id
  has_many :followers, through: :relations_to

  VALID_PATTERNS = [:tweet_count, :friends_count, :followers_count].freeze

  def friends_by(pattern, order_direction = :desc, limit = 50)
    validate_search_pattern(pattern)
    friends.order(pattern => order_direction).limit(limit)
  end

  def followers_by(pattern, order_direction = :desc, limit = 50)
    validate_search_pattern(pattern)
    followers.order(pattern => order_direction).limit(limit)
  end

  private

  def validate_search_pattern(pattern)
    unless VALID_PATTERNS.include?(pattern)
      fail "Invalid search pattern. Use #{VALID_PATTERNS.inspect}."
    end
  end
end
