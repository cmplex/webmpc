$(document).ready(function (){

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

	// setup timer that fetches current song information and updates the page
	var songDescrUpdater = setInterval(function() {
		// update title
		$.get('mpd_client.php', {func: "getCurrentTitle"}, function(response) {
			$('#title').html(response);
		});

		// update artist
		$.get('mpd_client.php', {func: "getCurrentArtist"}, function(response) {
			$('#artist').html(response);
		});

		// update album
		$.get('mpd_client.php', {func: "getCurrentAlbum"}, function(response) {
			$('#album').html(response);
		});
	}, 1000);
});
