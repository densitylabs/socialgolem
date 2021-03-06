window.availableUserCount = 0
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
        var userLimit = $('meta[name="fn-users-per-page"]').attr('content');

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

        var followUserUrl = $('meta[name="fn-url-follow-user"]').attr('content');

        function updateLoader() {
          var currentProgress = (window.availableUserCount * 100) / window.relatedUserCount;

          if (currentProgress < 100) {
            $loader.find('.determinate')
              .css('width', currentProgress + '%');
          } else {
            $loader.css('height', '0');
          };
        };

        function renderUsers(users, afterComplete) {
          amountOfUsersToPrint = userLimit - window.displayedUserCount;

          if (users.length <= 0) return false;
          if (amountOfUsersToPrint <= 0) return false;

          $internalLoader.fadeOut('fast');

          if (users.length >= amountOfUsersToPrint) {
            var loopSize = amountOfUsersToPrint;
          } else {
            var loopSize = users.length;
          };

          for (var i = 0; i < loopSize; i++) {
            var user = users[i];
            var isFriend = window.currentUserIds.indexOf(
              user['twitter_id']) != -1;

            $('head style').append('.' + user['screen_name']
              + '::after{ background: url("' + user['profile_image_url']
              + '") no-repeat center center/cover }');

            $usersContainer.append(compiled_template({ user: user,
                                                       isFriend: isFriend }));
            window.displayedUserCount = window.displayedUserCount + 1;
          };

          if (typeof afterComplete === 'function') afterComplete();
        };

        function fetchUsersInPage(pageNumber, event) {
          $usersContainer.empty();
          $internalLoader.fadeIn('fast');
          window.displayedUserCount = 0;

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
              items: window.availableUserCount,
              itemsOnPage: userLimit,
              cssStyle: 'light-theme',
              onPageClick: fetchUsersInPage
          });
        };

        function enableControls() {
          $('.fn-form').fadeIn('fast');

          $relationControl.material_select();
          $filterControl.material_select();

          $pagination.parent().fadeIn('fast');
        };

        function reactToInitialMessage() {
          window.relatedUserCount = data['related_user_count'];
          window.availableUserCount = window.availableUserCount + data['local_user_count'];
          window.currentUserIds = data['current_user_ids'] || [];
        };

        function allUsersFetched() {
          return window.relatedUserCount <= window.availableUserCount;
        };

        function userHasBeenFollowed() {
          $(this).fadeOut('fast').remove();
        };

        function followUser(e) {
          e.preventDefault();

          var id = $(this).attr('href');

          $.ajax({
            url: followUserUrl,
            type: 'POST',
            data: { id: id }
          })
          .done(userHasBeenFollowed.bind(this));
        };

        function afterRenderingUsers() {
          $('a.fn-follow').click(followUser);
        };

        if (data['is_base_message'] != undefined) {
          reactToInitialMessage();
        } else {
          window.availableUserCount = window.availableUserCount + data['users'].length;
        };

        renderUsers(data['users'], afterRenderingUsers);

        if (allUsersFetched()) enableControls();

        updateLoader(window.availableUserCount);
        updatePagination(window.availableUserCount);

        $filterControl.change(function(){
          $pagination.pagination('selectPage', 1);
        });
      }
    }
  );
};
