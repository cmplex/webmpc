// vim: ts=4 sw=4 noet
$(document).ready(function (){
	// state variables
	var album;
	var artist;
	var title;

	// setup timer that fetches current song information and updates the page
	setInterval(function() {
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
	}, 1000);



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
			if(response == 0) {
				$('#prevbutton').fadeTo('fast', 1.0);
			}
		});

	});

	$('#nextbutton').click(function(){
		$(this).fadeTo('fast', 0.3);

		$.get('mpd_client.php', {func: "controlNext"}, function(response) {
			if(response == 0) {
				$('#nextbutton').fadeTo('fast', 1.0);
			}
		});

	});

	$('#togglebutton').click(function(){
		$(this).fadeTo('fast', 0.3);

		$.get('mpd_client.php', {func: "controlToggle"}, function(response) {
			if (response == 0) {
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
			$.get('mpd_client.php', {func: "playSong", params: songid}, function(response) {});

			$('.playlist_elem').fadeTo('fast', 0.6);
			$(this).fadeTo('fast', 1);
		});
	});
});
