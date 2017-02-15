$(document).ready(function() {
	// show login errors
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

	// modal login form
	$('#modal-login-form').submit(function(e) {
		e.preventDefault();
		var $t = $(this);
		$.ajax({
			url: $t.attr('action'),
			method: 'POST', 
			data: $t.serialize(),
			dataType: 'json',
			success: function(data) {
				if (data === 'Invalid email.' || data === 'Incorrect password.') {
					$('#modal-login-form > .error-msg').html(data).hide().fadeIn(500);
				} else {
					var currentUrl = $(location).attr('href');
					currentUrl = currentUrl.slice(0, -6);
					window.location.replace(currentUrl);
				}
			}
		});
	});

	// show signup errors
	$('#signup-form').submit(function(e) {
		e.preventDefault();
		$.ajax({
			url: '/users',
			method: 'POST', 
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {

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

	// indication for upvotes and un-upvotes
	$('.upvote-form').submit(function(e) {
		e.preventDefault();
		var $t = $(this)
		$.ajax({
			url: $t.attr('action'),
			method: 'POST',
			data: $t.serialize(),
			dataType: 'json',
			success: function(data) {
				var upvotes = $t.children().text();
				if (data === "upvote") {
					upvotes = parseInt(upvotes) + 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span> ' + upvotes);
					$t.children().addClass('btn-grey');
				} else if (data === "un-upvote") {
					upvotes = parseInt(upvotes) - 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span> ' + upvotes);
					$t.children().removeClass('btn-grey');
				} else if (data === "upvote un-downvote") {
					upvotes = parseInt(upvotes) + 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span> ' + upvotes);
					$t.children().addClass('btn-grey');

					var downvotes = $t.next().children().text();
					downvotes = parseInt(downvotes) - 1;
					$t.next().children().html('<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span> ' + downvotes);
					$t.next().children().removeClass('btn-grey');
				} else {
			    $('[data-remodal-id=modal]').remodal().open();
					// window.location.replace(data);
				}
			}
		});
	});

	// indication for downvotes and un-downvotes
	$('.downvote-form').submit(function(e) {
		e.preventDefault();
		var $t = $(this)
		$.ajax({
			url: $t.attr('action'),
			method: 'POST',
			data: $t.serialize(),
			dataType: 'json',
			success: function(data) {
				var downvotes = $t.children().text();
				if (data === "downvote") {
					downvotes = parseInt(downvotes) + 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span> ' + downvotes);
					$t.children().addClass('btn-grey');
				} else if (data === "un-downvote") {
					downvotes = parseInt(downvotes) - 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span> ' + downvotes);
					$t.children().removeClass('btn-grey');
				} else if (data === "un-upvote downvote") {
					downvotes = parseInt(downvotes) + 1;
					$t.children().html('<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span> ' + downvotes);
					$t.children().addClass('btn-grey');

					var upvotes = $t.prev().children().text();
					upvotes = parseInt(upvotes) - 1;
					$t.prev().children().html('<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span> ' + upvotes);
					$t.prev().children().removeClass('btn-grey');
				} else {
			    $('[data-remodal-id=modal]').remodal().open();
					// window.location.replace(data);
				}
			}
		});
	});

	// creates an answer for a question
	$('#answer-form').submit(function(e) {
		e.preventDefault();
		var $t = $(this);
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {
				if (data === 'You did not provide an answer.') {
					$t.find('.error-msg').html(data).hide().fadeIn(500);
				} else if (data === '/sessions/new') {
			    $('[data-remodal-id=modal]').remodal().open();
				} else {
					window.location.replace(data);
				}
			}
		});
	});

	// creates a question
	$('.navbar-form').submit(function(e) {
		e.preventDefault();
		var $t = $(this);
		$.ajax({
			url: $(this).attr('action'),
			method: 'POST',
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {
				console.log(data);
				if (data === '/sessions/new') {
			    $('[data-remodal-id=modal]').remodal().open();
				} else if (data === 'Eh WHere question?!?!') {
					$t.find('label').html(data).hide().fadeIn(500);
				} else {
					window.location.replace(data);
				}
			}
		});
	});

	$('.delete-button').submit(function(e) {
		e.preventDefault();
		var $t=$(this);
		$.ajax({
			url: $(this).attr('action'),
			method: 'DELETE',
			data: $(this).serialize(),
			dataType: 'json',
			success: function(data) {
				$t.parent().fadeOut(500);
			}
		});
	})

});