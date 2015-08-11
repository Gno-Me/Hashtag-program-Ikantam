(function($) {
  $(function() {

    var $hashtagAdd = $('.hashtag-add');
    var $hashtagForm = $('.add-new-hashtag').find('form');
    var $hashtagName = $hashtagForm.find('[name="hashtag[name]"]');

    $hashtagForm.parsley();

    // clear input value on page load because of turbolinks
    $hashtagName.val('');

    // show input on click
    $('.btn-matt').on('click', function() {
      var $this = $(this),
        $parent   = $this.parent(),
        $newHashtag = $parent.find('.add-new-hashtag');

      $this.hide();
      $newHashtag.show();

      $hashtagName.focus();

      return false;
    });


    $hashtagForm.on('submit', function(ev) {
      // check if button was already clicked
      if ($hashtagAdd.attr('disabled')) {
        return false;
      }
      $hashtagAdd.attr('disabled', true);

      // remove manually added errors
      window.ParsleyUI.removeError($hashtagName.parsley(), 'hashtag');

      if ($(this).parsley().isValid()) {

        var url = $hashtagForm.attr('action');
        var data = $hashtagForm.serialize();

        // send server request with form data
        $.post(url, data)
          .done(function(response, status, jqXHR) {
            // redirect to hashtag if it was successfully created
            window.location.href = Routes.hashtag_path(response.id);
          })
          .fail(function(jqXHR, textStatus, errorThrown) {

            // 422 status means validation error
            // any other status is unexpected
            if (jqXHR.status === 422) {
              var errors = $.parseJSON(jqXHR.responseText);
            } else {
              var errors = { name: ['Unknown error'] };
            }

            for (var name in errors) {
              var messages = errors[name];
              for (var key in messages) {
                var message = '- ' + messages[key];
                // render custom error
                window.ParsleyUI.addError($hashtagName.parsley(), 'hashtag', message);
              }
            }

          })
          .always(function() {
            $hashtagAdd.removeAttr('disabled');
          });

      } else {
        $hashtagAdd.removeAttr('disabled');
      }
      
      return false;
    });

  });
})(jQuery);