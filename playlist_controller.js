// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser


////////////////////////////////////////
//         C O N S T A N T S          //
////////////////////////////////////////

var OPACITY = 0.6;



////////////////////////////////////////
//         B E H A V I O U R          //
////////////////////////////////////////

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

		$('.playlist_elem').fadeTo('fast', OPACITY);
		$(this).fadeTo('fast', 1);
	});
});
