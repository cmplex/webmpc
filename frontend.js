// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser


$(document).ready(function (){
	// source views and controllers
	$.getScript("song_view.js", function(){});
	$.getScript("song_controller.js", function(){});
	$.getScript("playlist_controller.js", function(){});


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
		$('#playlistview').show();
	});


	// "library"-button specific behaviour
	$('#searchbutton').click(function(){
		$('.modeview').hide();
		$('#searchview').fadeIn();
	});
});
