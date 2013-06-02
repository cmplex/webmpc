// @author Sebastian Neuser

$(document).ready(function(){

	////////////////////////////////////////
	//         C O N S T A N T S          //
	////////////////////////////////////////

	var OPACITY = 0.4;



	////////////////////////////////////////
	//         B E H A V I O U R          //
	////////////////////////////////////////

	function displayArtists() {
		$.get('mpd_client.py/listArtists', function(artists) {
			// fade out and clear old list
			$('#browselist').fadeOut('fast');
			$('#browselist').empty();

			for (index=0; index < artists.length; index++) {
				$('#browselist').append('<div id="artist' + index + '" class="browselist_elem">');
				$('#artist'+index).append('<div>' + artists[index] + '</div>');

				// setup onClick event handler
				$('#artist'+index).mouseup(displayAlbums);
			}

			// fade in the new list
			$('#browselist').fadeIn('fast');
		}, 'json');
	}

	function displayAlbums() {
		$.get('mpd_client/listAlbums', {artist : $(this).find('div').text()}, function(albums) {
			// fade out and clear old list
			$('#browselist').fadeOut('fast');
			$('#browselist').empty();

			// add back button
			$('#browselist').append('<div id="back_button" class="browselist_elem">');
			$('#back_button').append('<div>&larr;</div></div>');
			$('#back_button').mouseup(displayArtists);

			// add albums to the list and setup onClick handlers
			for (index=0; index < albums.length; index++) {
				$('#browselist').append('<div id="album' + index + '" class="browselist_elem">');
				$('#album'+index).append('<div>' + albums[index] + '</div>');
				$('#album'+index).mouseup(displaySongs);
			}

			// fade in the new list
			$('#browselist').fadeIn('fast');
		}, 'json');
	}

	function displaySongs() {
	}


	// initialize browse list
	displayArtists();
});
