App.twitter_user_info = App.cable.subscriptions.create "TwitterUserInfoChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    html_template = $('#fn-user-template')
    compiled_template = _.template(html_template.html())
    $usersContainer = $('#fn-users-container')

    # $('head style').append(".card_3::after{ background: url('https://pbs.twimg.com/profile_images/458818606654963713/V7LYqGZG.jpeg') }");

    if ($usersContainer.hasClass('fn-empty') == true)
      $usersContainer.empty().removeClass('fn-empty');

    for user in data['users']
      $('head style').append('.' + user['screen_name'] +  '::after{ background: url("' +
        user['profile_image_url'] + '") no-repeat center center/cover }');

      $usersContainer.append(
        compiled_template({ user: user })
      );
