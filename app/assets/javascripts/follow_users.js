$(document).ready(function(){
  var followUserUrl = $('meta[name="fn-url-follow-user"]').attr('content');

  function userHasBeenFollowed() {
    $(this).fadeOut('fast').remove();
  };

  function followUser(e) {
    e.preventDefault();

    var id = $(this).attr('href');

    $.ajax({
      url: followUserUrl,
      type: 'POST',
      data: {
        id: id,
        id_type: 'twitter_id'
      }
    })
    .done(userHasBeenFollowed.bind(this));
  };

  $('a.fn-follow').click(followUser);
});
