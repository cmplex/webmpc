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
		$.get('mpd_client/listSongs', {album : $(this).find('div').text()}, function(songs) {
			// fade out and clear old list
			$('#browselist').fadeOut('fast');
			$('#browselist').empty();

			// add back button
			$('#browselist').append('<div id="back_button" class="browselist_elem">');
			$('#back_button').append('<div>&larr;</div></div>');
			$('#back_button').mouseup(displayArtists);

			// add songs to the list and setup onClick event handlers
			for (index=0; index < songs.length; index++) {
				$('#browselist').append('<div id="browse_song' + index + '" class="browselist_elem">');
				$('#browse_song'+index).append('<div class="songinfo title">'  + songs[index][0] + '</div>');
				$('#browse_song'+index).append('<div class="songinfo artist">' + songs[index][2] + '</div>');
				$('#browse_song'+index).append('<div class="songinfo album">'  + songs[index][1] + '</div>');

				// show only the song title
				$('#browse_song'+index+' div').hide();
				$('#browse_song'+index+' div:first-child').show();

				// setup onClick event handler
				$('#browse_song'+index).mouseup(onSongItemClick);
			}

			// fade in the new list
			$('#browselist').fadeIn('fast');
		}, 'json');
	}

	// onClick event handler for song items
	function onSongItemClick() {
		if($(this).data('clicked') == 'true')
		{
			// read songid from the hidden element and start playback
			clickedTitle = $(this).find('.title').text();
			clickedArtist = $(this).find('.artist').text();
			clickedAlbum = $(this).find('.album').text();
			$.post('mpd_client.py/addSong', {title: clickedTitle, album: clickedAlbum, artist: clickedArtist});
			$(this).fadeTo('fast', 0.4);
			$(this).fadeTo('fast', 0.6);
		}
		else
		{
			// remove "clicked" flag of other items, set it on the clicked one
			$('.browselist_elem').removeData('clicked');
			$(this).data('clicked', 'true');

			// hide other song descriptions, show specific song description
			$('.browselist_elem div').hide();
			$('.browselist_elem div:first-child').show();
			$(this).children('.songinfo').fadeIn();
		}
	}


	// initialize browse list
	displayArtists();
});
