window.userId = window.location.pathname.split('/')[2];

// Subscription to ActionCable
function changeChannelSubscriptionTo(relation) {
  App.subscriptions['twitterUserInfo'].unsubscribe();
  App.subscriptions['twitterUserInfo'] = App.createTwitterUserInfoSubscription(
    userId, relation);
};

var relation = document.head.querySelector("[name=fn-relation").content || 'friends';

App.subscriptions['twitterUserInfo'] = App.createTwitterUserInfoSubscription(
  userId, relation);

$(window).load(function() {
  var $relationControl = $('#fn-relation-control');

  var urlWithoutParams = location.protocol + '//' + location.host + location.pathname;

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

  function navigateToRelation() {
    newUrl = urlWithoutParams + '?relation=' + $(this).val();
    window.location.replace(newUrl);
  };

  $relationControl.change(navigateToRelation);

  requestRelatedUsers(relation, beforeRequestRelatedUsers);
});
