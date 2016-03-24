App.twitter_user_info = App.cable.subscriptions.create "TwitterUserInfoChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    users = JSON.parse(data['users'])
    html_template = $('#fn-user-template')
    compiled_template = _.template(html_template.html())
    $usersContainer = $('#fn-users-container')

    if ($usersContainer.hasClass('fn-empty') == true)
      $usersContainer.empty().removeClass('fn-empty');

    debugger
    for user in users
      $usersContainer.append(
        compiled_template({ user: user })
      );
