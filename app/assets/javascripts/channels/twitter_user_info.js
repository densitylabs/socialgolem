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
        var $internalLoader = $('.fn-loader-container');

        var $relationControl = $('#fn-relation-control');
        var $filterControl = $('#fn-filter-control');

        var $pagination = $('.fn-pagination');

        var $usersContainer = $('#fn-users-container');
        var html_template = $('#fn-user-template');
        var compiled_template = _.template(html_template.html());

        var filterRelatedUsersURL = $('meta[name="fn-filter-related-users-url"]')
                                      .attr('content');

        function updateLoader() {
          var currentProgress = (window.userCount * 100) / window.usersTotal;

          if (currentProgress < 100) {
            $loader.find('.determinate')
              .css('width', currentProgress + '%');
          } else {
            $loader.css('height', '0');
          };
        };

        function renderUsers(users) {
          $internalLoader.fadeOut('fast');

          if (users.length > 50) {
            var loopSize = 50;
          } else {
            var loopSize = users.length;
          };

          for (var i = 0; i < loopSize; i++) {
            var user = users[i];

            $usersContainer.append(compiled_template({ user: user }));
          };
        };

        function fetchUsersInPage(pageNumber, event) {
          $usersContainer.empty();
          $internalLoader.fadeIn('fast');

          $.ajax({
            url: filterRelatedUsersURL,
            data: {
              page: pageNumber,
              related_users: $relationControl.val(),
              pattern: $filterControl.val(),
              user_id: userId
            }
          })
          .done(renderUsers)
          // .fail(onFail)
        };

        function updatePagination() {
          $pagination.pagination({
              items: window.userCount,
              itemsOnPage: 50,
              cssStyle: 'light-theme',
              onPageClick: fetchUsersInPage
          });
        };

        function unfreezeControls() {
          $('.fn-form').fadeIn('fast');

          $relationControl.material_select();
          $filterControl.material_select();

          $pagination.parent().fadeIn('fast');
        };

        function reactToInitialMessage() {
          window.usersTotal = data['users_total'];
          window.userCount = window.userCount + data['available_local_total'];

          $internalLoader.fadeOut('fast');
          $usersContainer.removeClass('fn-empty');

          renderUsers(data['users']);
        };

        function allUsersFetched() {
          return window.usersTotal == window.userCount;
        };

        if (data['initial_message'] != undefined) {
          reactToInitialMessage();
        } else {
          window.userCount = window.userCount + data['users'].length;
        };

        if (allUsersFetched()) unfreezeControls();

        updateLoader(window.userCount);
        updatePagination(window.userCount);
      }
    }
  );
};
