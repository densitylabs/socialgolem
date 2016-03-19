class User < ActiveRecord::Base
  validates :screen_name, uniqueness: true

  # Attempts to find a user by the finder if so it updates her with fields,
  # otherwise it creates her.
  def self.find_or_create_user_with(finder, fields)
    binding.pry
    user = User.find_or_initialize_by(finder)
    user.update_attributes!(fields)
    user
  end
end
