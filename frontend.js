$(document).ready(function (){

	var cur_title;
	var rec_title;
	var cur_artist;
	var rec_artist;
	var cur_album;
	var rec_album;

	// song description updater
	var showSongDescr = function() {

			// update title
			$.get('mpd_client.php', {func: "getCurrentTitle"}, function(response) {
				
				rec_title = cur_title;
				cur_title = response;
				
				if(cur_title != rec_title){
					$('#title').html(response);
				}

			});

			// update artist
			$.get('mpd_client.php', {func: "getCurrentArtist"}, function(response) {

				rec_artist = cur_artist;
				cur_artist = response;

				if(cur_artist != rec_artist) {
					$('#artist').html(response);
				}

			});

			// update album
			$.get('mpd_client.php', {func: "getCurrentAlbum"}, function(response) {

				rec_album = cur_album;
				cur_album = response;

				if(cur_album != rec_album) {
					$('#album').html(response);
					$('#albumart').html("<img src='covers/"+response+".jpg'></img>");
				}

			});
	}



	// hide all views by default
	$('.modeview').hide();
	$('#songview').show();

	// general view button behaviour
	$('.modebutton').click(function(){
		$('.modebutton').fadeTo('fast',0.4);
		$(this).fadeTo('fast', 1);
	});

	// "song"-button specific behaviour
	$('#songbutton').click(function(){
		$('.modeview').hide();
		$('#songview').fadeIn();
	});

	// "playlist"-button specific behaviour
	$('#playlistbutton').click(function(){
		$('.modeview').hide();
		$('#playlistview').fadeIn();
	});


	// "library"-button specific behaviour
	$('#searchbutton').click(function(){
		$('.modeview').hide();
		$('#searchview').fadeIn();
	});

	// playlist entry general behaviour
	$('.playlist_elem #songdescr div').hide();
	$('.playlist_elem #button_container').hide();
	$('.playlist_elem #songdescr div:first-child').show();


	$('.playlist_elem').click(function(){
		// element highlighting
		$('.playlist_elem').fadeTo('fast', 0.6);
		$(this).fadeTo('fast', 1);

		// hide other song descriptions, show specific song description
		$('.playlist_elem #songdescr div').hide();
		$('.playlist_elem #button_container').hide();
		$('.playlist_elem #songdescr div:first-child').show();
		$(this).children().children().fadeIn();
		$(this).find('#button_container').fadeIn();
	});


	showSongDescr();
	// setup timer that fetches current song information and updates the page
	var songDescrUpdater = setInterval(showSongDescr, 1000);
});
