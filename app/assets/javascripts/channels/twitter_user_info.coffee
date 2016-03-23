App.twitter_user_info = App.cable.subscriptions.create "TwitterUserInfoChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    console.log(data)

  # speak: (message) ->
  #   @perform 'speak', message: message
