// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser


$(document).ready(function (){
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
