// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser

$(document).ready(function(){

	////////////////////////////////////////
	//         C O N S T A N T S          //
	////////////////////////////////////////

	var OPACITY = 0.4;



	////////////////////////////////////////
	//         B E H A V I O U R          //
	////////////////////////////////////////

	// song controls
	
	$('#prevbutton').click(function(){
		// fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/prev', function() {
			// fade in
			$('#prevbutton').fadeTo('fast', 1.0);
		});
	});


	$('#nextbutton').click(function(){
		// fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/next', function() {
			// fade in
			$('#nextbutton').fadeTo('fast', 1.0);
		});
	});


	$('#togglebutton').click(function(){
		// fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/toggle', function() {
			// fade in
			$('#togglebutton').fadeTo('fast', 1.0);
		});
	});



	// volume controls

	$('#minusbutton').click(function(){
		//fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/lowerVolume', function() {
			// fade in
			$('#minusbutton').fadeTo('fast', 1.0);
		});
	});

	
	$('#plusbutton').click(function(){
		//fade out
		$(this).fadeTo('fast', OPACITY);

		$.get('mpd_client.py/raiseVolume', function() {
			// fade in
			$('#plusbutton').fadeTo('fast', 1.0);
		});
	});

	$('#progressbar-container').click(function(e){
		// get x-position relative to progressbar-container
		var xpos = e.pageX - this.offsetLeft;
		// x-pos / max-x - ratio
		var seek_factor = xpos / $(this).width();

		$.post('mpd_client.py/setTrackProgress', {factor: seek_factor});
	});

});
