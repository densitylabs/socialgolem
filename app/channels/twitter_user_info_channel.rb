# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class TwitterUserInfoChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'twitter_user_info'
  end

  def unsubscribed
  end
end
