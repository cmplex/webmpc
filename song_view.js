// vim: ts=4 sw=4 noet
// @author Cedric Haase
// @author Sebastian Neuser

// state variables
var album;
var artist;
var title;

// setup timer that fetches current song information and updates the page
function updateSongView() {

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

			// create img tag with appropriate src
			var albumimg = document.createElement("img");
			albumimg.src = "covers/default.png";
			$('#albumart').html(albumimg);

			// check if cover exists
			var imgurl = "covers/"+response+".jpg";
			$.ajax({
				url:imgurl,
				type:'HEAD',
				success: function() {
					// cover does exist
					albumimg.src = imgurl;
				}
			});
		}
	});
}

// initialize view
updateSongView();

// schedule update
setInterval(updateSongView, 1000);
