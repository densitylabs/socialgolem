$(window).load(function() {
  var userId = window.location.pathname.split('/')[2];
  var relationType = $('meta[name="fn-relation-type"]').attr('content');

  var $friendsBtn = $("#fn-friends");
  var $followersBtn = $("#fn-followers");
  var $relationText = $('.fn-relation-type-text');

  // text
  if (relationType == 'friends') {
    updateRelationText('following');
  } else {
    updateRelationText(relationType);
  };

  function updateRelationText(relation) {
    $relationText.text(relation);
  }

  function requestRelatedUsers(relationType, beforeExecute) {
    if (beforeExecute) beforeExecute();

    // server request
    $.ajax({
      url: $('meta[name="fn-user-relations-url"]').attr('content'),
      data: { id: userId, relation_type: relationType }
    })
  };

  function beforeRequestRelatedUsers() {
    $('#fn-users-container').empty();
  };

  function fetchFriends() {
    if ($(this).not(":checked").length) return;

    $followersBtn.prop('checked', false);
    updateRelationText('friends');
    requestRelatedUsers('friends', beforeRequestRelatedUsers);
  };

  function fetchFollowers() {
    if ($(this).not(":checked").length) return;

    $friendsBtn.prop('checked', false);
    updateRelationText('followers');
    requestRelatedUsers('followers', beforeRequestRelatedUsers);
  };

  $($friendsBtn).change(fetchFriends);
  $($followersBtn).change(fetchFollowers);

  requestRelatedUsers(relationType);
});
