window.userId = window.location.pathname.split('/')[2];

// Subscription to ActionCable
function changeChannelSubscriptionTo(relation) {
  App.subscriptions['twitterUserInfo'].unsubscribe();
  App.subscriptions['twitterUserInfo'] = App.createTwitterUserInfoSubscription(
    userId, relation);
};

App.subscriptions['twitterUserInfo'] = App.createTwitterUserInfoSubscription(
  userId, 'friends');

$(window).load(function() {
  // var $friendsBtn = $("#fn-friends");
  // var $followersBtn = $("#fn-followers");
  // var $relationText = $('.fn-relation-type-text');

  function requestRelatedUsers(relationType, beforeExecute) {
    if (beforeExecute) beforeExecute();

    $.ajax({
      url: $('meta[name="fn-user-relations-url"]').attr('content'),
      data: { id: userId, relation_type: relationType }
    })
  };

  function beforeRequestRelatedUsers() {
    $('#fn-users-container').empty();
  };

  // function fetchFriends(e) {
  //   if ($(this).not(":checked").length) return;
  //
  //   $followersBtn.prop('checked', false);
  //   changeChannelSubscriptionTo('friends');
  //   requestRelatedUsers('friends', beforeRequestRelatedUsers);
  // };
  //
  // function fetchFollowers(e) {
  //   if ($(this).not(":checked").length) return;
  //
  //   $friendsBtn.prop('checked', false);
  //   changeChannelSubscriptionTo('followers');
  //   requestRelatedUsers('followers', beforeRequestRelatedUsers);
  // };
  //
  // $friendsBtn.change(fetchFriends);
  // $followersBtn.change(fetchFollowers);

  requestRelatedUsers('friends', beforeRequestRelatedUsers);

  // $('#fn-filter-control').change(fetchRelation);
});
