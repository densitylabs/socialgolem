class User < ActiveRecord::Base
  validates :screen_name, uniqueness: true

  has_one :twitter_user, foreign_key: :twitter_id, primary_key: :twitter_id

  # Attempts to find a user by the finder if so it updates her with fields,
  # otherwise it creates her.
  def self.find_or_create_user_with(finder, fields)
    user = User.find_or_initialize_by(finder)
    user.update_attributes!(fields)
    user
  end

  def add_friend(id)
    TwitterUserRelation.create(from_id: twitter_id, to_id: id)
  end
end
