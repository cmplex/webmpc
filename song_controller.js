// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser


////////////////////////////////////////
//         C O N S T A N T S          //
////////////////////////////////////////

var OPACITY = 0.4;



////////////////////////////////////////
//         B E H A V I O U R          //
////////////////////////////////////////

$('#prevbutton').click(function(){
	// fade out
	$(this).fadeTo('fast', OPACITY);

	$.get('mpd_client.php', {func: "controlPrevious"}, function() {
		// fade in
		$('#prevbutton').fadeTo('fast', 1.0);
	});
});


$('#nextbutton').click(function(){
	// fade out
	$(this).fadeTo('fast', OPACITY);

	$.get('mpd_client.php', {func: "controlNext"}, function() {
		// fade in
		$('#nextbutton').fadeTo('fast', 1.0);
	});
});


$('#togglebutton').click(function(){
	// fade out
	$(this).fadeTo('fast', OPACITY);

	$.get('mpd_client.php', {func: "controlToggle"}, function() {
		// fade in
		$('#togglebutton').fadeTo('fast', 1.0);
	});
});