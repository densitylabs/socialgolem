# Represents a twitter user.
class TwitterUser < ActiveRecord::Base
  has_many :relations_from, class_name: 'TwitterUserRelation', foreign_key: :from_id
  has_many :friends, through: :relations_from

  has_many :relations_to, class_name: 'TwitterUserRelation', foreign_key: :to_id
  has_many :followers, through: :relations_to

  belongs_to :user, foreign_key: :twitter_id, primary_key: :twitter_id

  validates :twitter_id, uniqueness: true

  SUPPORTED_SEARCH_PATTERNS = %w(statuses_count friends_count followers_count).freeze

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

  def register_friend_ids(ids)
    existent_ids = friends.where(twitter_id: ids).pluck(:twitter_id)
    to_create_ids = ids - existent_ids

    friends.create(to_create_ids.map { |id| { twitter_id: id } })
    update_attributes(friends_verified_on: Time.current)
    ids
  end

  def link_related_user_ids(ids, relation)
    linked_user_ids = send(relation).where(twitter_id: ids).pluck(:twitter_id)
    ids -= linked_user_ids

    unlinked_users = TwitterUser.where(twitter_id: ids).select(:id, :twitter_id)
    ids -= unlinked_users.pluck(:twitter_id)

    link_user_ids(unlinked_users.pluck(:id), relation)
    send(relation).create(ids.map { |id| { twitter_id: id } })

    update_attributes("#{relation}_verified_on" => Time.current)
  end

  def link_user_ids(ids, relation)
    data = if relation == 'friends'
             ids.map { |id| { from_id: self.id, to_id: id } }
           else # followers
             ids.map { |id| { from_id: id, to_id: self.id } }
           end

    TwitterUserRelation.create(data)
  end

  def relation_verified_after?(relation, datetime)
    send("#{relation}_verified_on") && send("#{relation}_verified_on") >= datetime
  end
end
