# Be sure to restart your server when you modify this file. Action Cable runs
# in a loop that does not support auto reloading.
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    protected

    def find_verified_user
      user = User.find(cookies.signed[:user_id])

      return user if user
      fail 'User needs to be authenticated.'
    end
  end
end
