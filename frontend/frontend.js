// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase
// @author Sebastian Neuser


$(document).ready(function (){

	////////////////////////////////////////
	//         C O N S T A N T S          //
	////////////////////////////////////////

	var OPACITY = 0.6;
	var UPDATE_INTERVAL = 500;


	//////////////////////////////
	//        SONG VIEW         //
	//////////////////////////////

	// state variables
	var album;
	var artist;
	var title;
	var progress;

	// setup timer that fetches current song information and updates the page
	function updateSongView() {

		// update title
		$.get('mpd_client.py/getCurrentTitle', function(response) {
			if(response != title){
				title = response;
				$('#title').hide();
				$('#title').html(response).fadeIn();
			}
		});

		// update artist
		$.get('mpd_client.py/getCurrentArtist', function(response) {
			if(response != artist) {
				artist = response;
				$('#artist').hide();
				$('#artist').html(response).fadeIn();
			}
		});

		// update album name & cover
		$.get('mpd_client.py/getCurrentAlbum', function(response) {
			if(response != album) {
				album = response;

				$('#album').hide();
				$('#album').html(response).fadeIn();

				// create img tag with appropriate src
				var albumimg = document.createElement("img");
				albumimg.src = "covers/default.png";
				$('#albumart').html(albumimg);

				// check if cover exists
				var imgurl = "covers/"+response+".jpg";
				$.ajax({
					url:imgurl,
					type:'HEAD',
					success: function() {
						// cover does exist
						albumimg.src = imgurl;
					}
				});
			}
		});

		// update progress bar
		$.get('mpd_client.py/getTrackProgress', function(response) {
			response = parseInt(response);
			if(response != progress) {
				progress = response;
				$('#progressbar').width(response+"%");
			}
		});
	}

	// initialize view
	updateSongView();

	// schedule update
	var songview_updater = setInterval(updateSongView, UPDATE_INTERVAL);



	///////////////////////////
	//     PLAYLIST VIEW     //
	///////////////////////////

	var old_playlist = [];
	var old_currentSongId = -1;


	function updatePlaylistView() {
		$.get('mpd_client.py/fetchPlaylist', function(response) {
			// parse response
			var currentSongId = response[0];
			var playlist = response[1];

			// update playlist items
			for (index=0; index < Math.max(playlist.length, old_playlist.length); index++) {
				// add items if the new playlist is longer
				if (index >= old_playlist.length || index == 0 && old_playlist.length == 0) {
					// create playlist entry
					$('#playlist').append('<div id="song' + index + '" class="playlist_elem">');

					// fill in song information
					$('#song'+index).append('<div class="songinfo title">'  + playlist[index][0] + '</div>');
					$('#song'+index).append('<div class="songinfo artist">' + playlist[index][2] + '</div>');
					$('#song'+index).append('<div class="songinfo album">'  + playlist[index][1] + '</div>');
					$('#song'+index).append('<div class="songid">'          + index              + '</div>');

					// show only the song title
					$('#song'+index+' div').hide();
					$('#song'+index+' div:first-child').show();

					// set onClick event handler
					$('#song'+index).mouseup(onPlaylistItemClick);

					continue;
				}

				// remove items if the new playlist is shorter
				if (index >= playlist.length) {
					$('#song'+index).remove();
					continue;
				}

				if (playlist[index] < old_playlist[index]
				||  playlist[index] > old_playlist[index]) {
					// update song information
					$('#song'+index+' .title').contents().replaceWith(playlist[index][0]);
					$('#song'+index+' .artist').contents().replaceWith(playlist[index][2]);
					$('#song'+index+' .album').contents().replaceWith(playlist[index][1]);
					$('#song'+index+' .songid').contents().replaceWith(''+index);
				}
			}

			// highlight currently playing song if it changed
			if (old_currentSongId != currentSongId) {
				$('.playlist_elem').fadeTo('fast', OPACITY);
				$('#song'+currentSongId).fadeTo('fast', 1.0);
				old_currentSongId = currentSongId;
			}

			// update playlist state variable
			old_playlist = playlist;
		}, 'json');
	}

	// onClick event handler for playlist items
	function onPlaylistItemClick() {
		if($(this).data('clicked') == 'true')
		{
			// read songid from the hidden element and start playback
			var songid = parseInt($(this).find('.songid').text());
			$.post('mpd_client.py/playSong', {number: songid});
		}
		else
		{
			// remove "clicked" flag of other items, set it on the clicked one
			$('.playlist_elem').removeData('clicked');
			$(this).data('clicked', 'true');

			// hide other song descriptions, show specific song description
			$('.playlist_elem div').hide();
			$('.playlist_elem div:first-child').show();
			$(this).children('.songinfo').fadeIn();
		}
	}

	// initialize view
	updatePlaylistView();

	// schedule updates
	var playlistview_updater;



	/////////////////////////////////
	//        MODE SWITCHER        //
	/////////////////////////////////


	// hide all views by default
	$('.modeview').hide();
	$('#songview').show();
	$('#songbutton').css({ opacity: 1.0 });


	// general view button behaviour
	$('.modebutton').click(function(){
		$('.modebutton').fadeTo('fast', 0.4);
		$(this).fadeTo('fast', 1);
	});


	// "song"-button specific behaviour
	$('#songbutton').click(function(){
		$('.modeview').hide();
		$('#songview').fadeIn();
		songview_updater = setInterval(updateSongView, UPDATE_INTERVAL);
		if(playlistview_updater){clearInterval(playlistview_updater);}
	});


	// "playlist"-button specific behaviour
	$('#playlistbutton').click(function(){
		$('.modeview').hide();
		$('#playlistview').fadeIn();
		playlistview_updater = setInterval(updatePlaylistView, UPDATE_INTERVAL);
		if(songview_updater){clearInterval(songview_updater);}

	});


	// "search"-button specific behaviour
	$('#searchbutton').click(function(){
		$('.modeview').hide();
		$('#searchview').fadeIn();
	});


	// "browse"-button specific behaviour
	$('#browsebutton').click(function(){
		$('.modeview').hide();
		$('#browseview').fadeIn();
	});
});
