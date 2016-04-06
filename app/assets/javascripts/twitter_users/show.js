$(window).load(function() {
  var $relationControl = $('#fn-relation-control');
  var urlWithoutParams = location.protocol + '//' + location.host + location.pathname;

  var userScreenName = $('meta[name="fn-user-screen-name"]').attr('content');

  function findRelation() {
    relation = $('meta[name="fn-relation"]').attr('content');

    if (relation == 'following') {
      return 'friends';
    } else {
      return relation;
    };
  };

  function requestRelatedUsers(relationType, beforeExecute) {
    if (beforeExecute) beforeExecute();

    $.ajax({
      url: $('meta[name="fn-user-relations-url"]').attr('content'),
      data: { id: userScreenName, relation_type: relationType }
    })
  };

  function beforeRequestRelatedUsers() {
    $('#fn-users-container').empty();
  };

  function navigateToRelation() {
    if ($(this).val() == 'following') {
      var url = $('meta[name="fn-friends-url"]').attr('content')
    } else { // followers
      var url = $('meta[name="fn-followers-url"]').attr('content')
    };

    window.location.replace(url);
  };

  $relationControl.change(navigateToRelation);

  // subscribe to channel to get updates about users
  App.subscriptions['twitterUserInfo'] = App.createTwitterUserInfoSubscription(
    userScreenName, findRelation());

  // ask backend to broadcast the users info
  requestRelatedUsers(findRelation(), beforeRequestRelatedUsers);
});
