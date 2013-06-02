// @author Sebastian Neuser

$(document).ready(function(){

	////////////////////////////////////////
	//         C O N S T A N T S          //
	////////////////////////////////////////

	var OPACITY = 0.4;



	////////////////////////////////////////
	//         B E H A V I O U R          //
	////////////////////////////////////////

	$.get('mpd_client.py/listArtists', function(artists) {
		for (index=0; index < artists.length; index++) {
			$('#browselist').append('<div class="browselist_elem"><div>' + artists[index] + '</div></div>');
		}
	}, 'json');

});
