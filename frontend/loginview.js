// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase

$(document).ready(function() {
	var OPACITY = 0.4;

	$('#gobutton').click(function() {
		$(this).fadeTo('fast', OPACITY).fadeTo('fast', 1.0);
		var name = $('#nameinput').val();
		var pass = $('#passwordinput').val();

		// submit query, get search results
		$.get('database_assistant/checkCredentials', {username: name, password: pass}, function(response) {
			// TODO create cookie [...]
			if (response == 'True')
				alert('Success.');
			else
				alert('Failure.');
		});
	});
});
