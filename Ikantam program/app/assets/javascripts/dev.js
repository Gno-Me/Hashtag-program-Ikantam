$(document).ready(function () {
  /*
  // commented now because not finished
  $('#new_user').validate({
    debug: true,
    submitHandler: function(form) {
      form.submit();
    },
    errorClass:'error',
    validClass:'success',
    errorElement:'span',
    errorPlacement: function(error, element) {
        element.next().html(error);
    },
    highlight: function(element, errorClass, message) {

      $(element).parent('div').addClass('error');
      $(element).addClass(errorClass);
    },
    unhighlight: function(element, errorClass) {
      $(element).parent('div').removeClass('error');
      $(element).removeClass(errorClass);
    },
    rules: {
    "user[first_name]": {required: true},
    "user[last_name]": {required: true},
    "user[email]": {email: true, required: true, remote: '/users/validate_email'},
    "user[password]": {required: true, minlength: 6},
    "user[username]": {remote: '/users/validate_username', required: true },
    },
    messages: {
      "user[password]": {
        minlength: 'minimum 6 symbols'
      },
      "user[email]": {
        email: 'Invalid e-mail address',
        remote: 'Already used'
      },
      "user[username]": {
        remote: 'Already used'
      }
    }
  });
*/
});