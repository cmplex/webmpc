// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser


$(document).ready(function (){

	////////////////////////////////////////
	//         C O N S T A N T S          //
	////////////////////////////////////////

	var OPACITY = 0.6;


	
	//////////////////////////////
	///		SONG VIEW		//////
	//////////////////////////////
	
	// state variables
	var album;
	var artist;
	var title;

	// setup timer that fetches current song information and updates the page
	function updateSongView() {

		// update title
		$.get('mpd_client.php', {func: "getCurrentTitle"}, function(response) {
			if(response != title){
				title = response;
				$('#title').hide();
				$('#title').html(response).fadeIn();
			}
		});

		// update artist
		$.get('mpd_client.php', {func: "getCurrentArtist"}, function(response) {
			if(response != artist) {
				artist = response;
				$('#artist').hide();
				$('#artist').html(response).fadeIn();
			}
		});

		// update album name & cover
		$.get('mpd_client.php', {func: "getCurrentAlbum"}, function(response) {
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
	}

	// initialize view
	updateSongView();

	// schedule update
	var songview_updater = setInterval(updateSongView, 1000);



	///////////////////////////
	/////	PLAYLIST VIEW	 	///
	///////////////////////////


	// TODO replacing instead of deleting and adding again
	function updatePlaylistView() {
		$.get('mpd_client.php', {func: "getPlaylistSize"}, function(size) {
			// empty playlist
			$('#playlist').empty();

			// fill playlist
			for (i=0; i<size; i++) {
				// create playlist entry
				$('#playlist').append('<div id="song' + i + '" class="playlist_elem">');

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


		// enable playlist controls after a slight delay
		setTimeout(function(){
			$('.playlist_elem').click(function(){

			var clicked = $(this).data('clicked');

			if(clicked == 'true')
			{
				// entry has been clicked before
				$(this).removeData('clicked');

				var songid = parseInt($(this).find('.songid').text());
				$.get('mpd_client.php', {func: "playSong", params: songid}, function(response) {});

				$('.playlist_elem').fadeTo('fast', OPACITY);
				$(this).fadeTo('fast', 1.0);
				
			}
			else
			{
				// entry has not been clicked before
				$(this).data('clicked', 'true');

				// hide other song descriptions, show specific song description
				$('.playlist_elem div').hide();
				$('.playlist_elem div:first-child').show();
				$(this).children('.songinfo').fadeIn();
			}		

		});
		},500);

	}

	// initialize view
	updatePlaylistView();

	// schedule updates
	var playlistview_updater = setInterval(updatePlaylistView, 10000);



	/////////////////////////////////
	///		MODESWITCHER 			///
	/////////////////////////////////


	// hide all views by default
	$('.modeview').hide();
	$('#songview').show();
	$('#songbutton').css({ opacity: 1.0 });
	clearInterval(playlistview_updater);


	// general view button behaviour
	$('.modebutton').click(function(){
		$('.modebutton').fadeTo('fast', 0.4);
		$(this).fadeTo('fast', 1);
	});


	// "song"-button specific behaviour
	$('#songbutton').click(function(){
		$('.modeview').hide();
		$('#songview').fadeIn();
		songview_updater = setInterval(updateSongView, 1000);
		if(playlistview_updater){clearInterval(playlistview_updater);}
	});


	// "playlist"-button specific behaviour
	$('#playlistbutton').click(function(){
		$('.modeview').hide();
		$('#playlistview').show();
		playlistview_updater = setInterval(updatePlaylistView, 10000);
		if(songview_updater){clearInterval(songview_updater);}

	});


	// "library"-button specific behaviour
	$('#searchbutton').click(function(){
		$('.modeview').hide();
		$('#searchview').fadeIn();
	});
});
