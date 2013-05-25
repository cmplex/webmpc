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
					$('#title').hide();
					$('#title').html(response).fadeIn();
				}

			});

			// update artist
			$.get('mpd_client.php', {func: "getCurrentArtist"}, function(response) {

				rec_artist = cur_artist;
				cur_artist = response;

				if(cur_artist != rec_artist) {
					$('#artist').hide();
					$('#artist').html(response).fadeIn();
				}

			});

			// update album name & cover
			$.get('mpd_client.php', {func: "getCurrentAlbum"}, function(response) {

				// check if album name changed
				rec_album = cur_album;
				cur_album = response;

				if(cur_album != rec_album) {
					$('#album').hide();
					$('#album').html(response).fadeIn();

					var imgurl = "covers/"+response+".jpg";

					// check if cover exists
					$.ajax({
						url:imgurl,
						type:'HEAD',
						error: function() {
							// cover does not exist
							albumimg.src = "covers/default.png";
						}					
					});

					// create img tag with appropriate src
					var albumimg = document.createElement("img");
					albumimg.src = imgurl;
					$('#albumart').html(albumimg);

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



	// control behaviour
	$('#prevbutton').click(function(){
		$(this).fadeTo('fast', 0.3);

		$.get('mpd_client.php', {func: "controlPrevious"}, function(response) {
			if(response == 0)
			{
				$('#prevbutton').fadeTo('fast', 1.0);
			}
		});

	});

	$('#nextbutton').click(function(){
		$(this).fadeTo('fast', 0.3);

		$.get('mpd_client.php', {func: "controlNext"}, function(response) {
			if(response == 0)
			{
				$('#nextbutton').fadeTo('fast', 1.0);
			}
		});

	});

	$('#togglebutton').click(function(){
		$(this).fadeTo('fast', 0.3);

		$.get('mpd_client.php', {func: "controlToggle"}, function(response) {
			if (response == 0)
			{
				$('#togglebutton').fadeTo('fast', 1.0);
			}
		});

	});



	// "song"-button specific behaviour
	$('#songbutton').click(function(){
		$('.modeview').hide();
		$('#songview').fadeIn();
	});

	// "playlist"-button specific behaviour
	$('#playlistbutton').click(function(){
		$('.modeview').hide();
		$('#playlistview').show();
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
		
		// hide other song descriptions, show specific song description
		$('.playlist_elem #songdescr div').hide();
		$('.playlist_elem #button_container').hide();
		$('.playlist_elem #songdescr div:first-child').show();
		$(this).children().children().fadeIn();
		$('.songid').hide();
		$(this).find('#button_container').fadeIn();

		// on second click
		$(this).click(function(){
			var songid = parseInt($(this).find('.songid').text());
			$.get('mpd_client.php', {func: "playSong", song: songid}, function(response) {});

			$('.playlist_elem').fadeTo('fast', 0.6);
			$(this).fadeTo('fast', 1);
		});
	});


	showSongDescr();
	// setup timer that fetches current song information and updates the page
	var songDescrUpdater = setInterval(showSongDescr, 1000);
});
