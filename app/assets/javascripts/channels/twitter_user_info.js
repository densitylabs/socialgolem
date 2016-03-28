App.createTwitterUserInfoSubscription = function(userId, realtion){
  return App.cable.subscriptions.create(
    {
      channel: 'TwitterUserInfoChannel',
      user_id: userId,
      relation: realtion
    },

    {
      connected: function() {},
      disconnected: function() {},

      received: function(data) {
        var html_template = $('#fn-user-template');
        var compiled_template = _.template(html_template.html());
        var $usersContainer = $('#fn-users-container');

        if ($usersContainer.hasClass('fn-empty') == true) {
          $usersContainer.empty().removeClass('fn-empty');
        };

        // console.log(data['users'].length);
        // console.log(new Date().toLocaleString());
        for (var i = 0; i < data['users'].length; i++) {
          var user = data['users'][i];

          // $('head style').append('.' + user['screen_name']
          //   + '::after{ background: url("' + user['profile_image_url']
          //   + '") no-repeat center center/cover }');

          $usersContainer.append(compiled_template({ user: user }));
        };
      }
    }
  );
};
