// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase

$(document).ready(function() {

	// receives the value of query input
	var query_value;
	
	var OPACITY = 0.4;


	function onSearchResultClick() {
		if($(this).data('clicked') == 'true')
		{
			// read songid from the hidden element and start playback
			var songid = parseInt($(this).data('songid'));
			$.post('mpd_client.py/addSearchResult', {query: query_value, number: songid});
			$(this).fadeTo('fast', 0.4);
			$(this).fadeTo('fast', 0.6);
		}
		else
		{
			// remove "clicked" flag from other items, set it on the clicked one
			$('.playlist_elem').removeData('clicked');
			$(this).data('clicked', 'true');

			// hide other song descriptions, show specific song description
			$('.result div').hide();
			$('.result div:first-child').show();
			$(this).children('.songinfo').fadeIn();
		}
	}

	$('#submitbutton').click(function() {
		$(this).fadeTo('fast', OPACITY);
		$('#searchresults').empty();

		query_value = document.getElementById("searchbox").value;

		// submit query, get search results
		$.get('mpd_client.py/fetchSearchResults', {query: query_value}, function(response) {

			var results = response;

			for(var index=0; index < results.length; index++) {
				// create search result entry
				$('#searchresults').append('<div id="result'+ index +'" class="result">');

				// fill in song information
				$('#result'+index).append('<div class="songinfo title">'		+ results[index][0] + '</div>');
				$('#result'+index).append('<div class="songinfo artist">'	+ results[index][2] + '</div>');
				$('#result'+index).append('<div class="songinfo album">'		+ results[index][1] + '</div>');
				
				$('#result'+index).data('songid', index);

				// show only the song title
				$('#result'+index+' div').hide();
				$('#result'+index+' div:first-child').show();

				// set onClick event handler
				$('#result'+index).click(onSearchResultClick);
				$('#result'+index).data('query', query_value);
			}

			$('#submitbutton').fadeTo('fast', 1.0);
		}, 'json');
	});

	$('#addallbutton').click(function(){
		
		// fade out
		$('#addallbutton').fadeTo('fast', OPACITY);

		$.get('mpd_client.py/addAllSearchResults', {query: query_value}, function(response) {
			// fade in
			$('#addallbutton').fadeTo('fast', 1.0);
		});
	});
	
	
});
