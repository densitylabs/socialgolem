window.userCount = 0
window.displayedUserCount = 0

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
        var $loader = $('.fn-user-load-progress');
        var html_template = $('#fn-user-template');
        var compiled_template = _.template(html_template.html());
        var $usersContainer = $('#fn-users-container');

        function setCounters() {
          window.usersTotal = data['users_total'];
          window.userCount = window.userCount + data['available_local_total'];
        };

        function updateLoader() {
          var currentProgress = (window.userCount * 100) / window.usersTotal;

          if (currentProgress < 100) {
            $loader.find('.determinate')
              .css('width', currentProgress + '%');
          } else {
            $loader.css('height', '0');
          };
        };

        function updatePagination() {
          $('.fn-pagination-container').pagination({
              items: window.userCount,
              itemsOnPage: 50,
              cssStyle: 'light-theme'
          });
        };

        if (data['initial_message'] != undefined) {
          setCounters();
        } else {
          window.userCount = window.userCount + data['users'].length;
        };

        updateLoader();
        updatePagination();

        if ($usersContainer.hasClass('fn-empty') == true && data['users']) {
          $usersContainer.empty().removeClass('fn-empty');

          if (data['users'].length > 50) {
            var loopSize = 50;
          } else {
            var loopSize = data['users'].length;
          };

          for (var i = 0; i < loopSize; i++) {
            var user = data['users'][i];

            $usersContainer.append(compiled_template({ user: user }));
          };
        };
      }
    }
  );
};
