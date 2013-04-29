//= require jquery

(function() {

	var form = $('#form-reset');

	form.submit(function() {

		var password = $('#password'),
			verify = $('#verify-password');

		if (password.val() != verify.val()) {
			$('#reset').after('<div id="flash"><div class="alert alert-error">Password doesn\'t match confirmation.</div></div>');

			return false;
		}
	});

}());