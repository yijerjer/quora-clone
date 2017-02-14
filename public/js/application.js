$(document).ready(function() {
	$('#login-form').submit(function(e) {
		e.preventDefault();
		$.ajax({
			url: '/sessions',
			method: 'POST', 
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {
				if (data === 'Invalid email.' || data === 'Incorrect password.') {
					$('#login-form > .error-msg').html(data).hide().fadeIn(500);
				} else {
					window.location.replace(data);
				}
			}
		});
	});

	$('#signup-form').submit(function(e) {
		e.preventDefault();
		$.ajax({
			url: '/users',
			method: 'POST', 
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {
				console.log(data);
				debugger

				if (data.email) {
					$($('#signup-form > .error-msg')[0]).html(data.email[0]).hide().fadeIn(500);
				} else {
					$($('#signup-form > .error-msg')[0]).html('');
				}
				if (data.password) {
					$($('#signup-form > .error-msg')[1]).html(data.password[0]).hide().fadeIn(500);
				} else {
					$($('#signup-form > .error-msg')[1]).html('');
				}
				if (data.password_confirmation) {
					$($('#signup-form > .error-msg')[2]).html('Passwords do not match.').hide().fadeIn(500);
				} else {
					$($('#signup-form > .error-msg')[2]).html('');
				}
				if (data === '/sessions/new') {
					window.location.replace(data);
				}

			}
		});
	});


});