// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser

$(document).ready(function(){

	// TODO replacing instead of deleting and adding again
	function updatePlaylistView() {
		$.get('mpd_client.php', {func: "getPlaylistSize"}, function(size) {
			// empty playlist
			$('#playlist').empty();
			$('#playlist').append('<br />');

			// fill playlist
			for (i=0; i<size; i++) {
				// create playlist entry
				$('#playlist').append('<div id="song' + i + '" class="playlist_elem">');
				$('#playlist').append('<br />');

				$.get('mpd_client.php', {func:"getPlaylistItem", params:i}, function(result) {
					$('#song'+result[0]).append('<div class="songinfo">' + result[1] + '</div>');
					$('#song'+result[0]).append('<div class="songinfo">' + result[2] + '</div>');
					$('#song'+result[0]).append('<div class="songinfo">' + result[3] + '</div>');
					$('#song'+result[0]).append('<div class="songid">'   + result[0] + '</div>');

					// show only the song title
					$('#song'+result[0]+' div').hide();
					$('#song'+result[0]+' div:first-child').show();
				}, 'json');
			}
		});
	}

	// initialize view
	updatePlaylistView();

	// schedule updates
	setInterval(updatePlaylistView, 10000);
});
