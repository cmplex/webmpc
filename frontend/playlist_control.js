// vim: tabstop=3 shiftwidth=3
// @ author Cedric Haase

$(document).ready(function(){

	var OPACITY = 0.4;

	$('#clearbutton').click(function(){
		// fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/clearPlaylist', function() {
			// fade in
			$('#clearbutton').fadeTo('fast', 1.0);
		});
	});
});
