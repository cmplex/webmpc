<?php
// vim: ts=4 sw=4 noet

include('config.php');
include('lib/mpd.class.php');



///////////////////////////////////////
//         C A L L B A C K S         //
///////////////////////////////////////

function setTrackProgress($mpd, $seek_factor) {
	$mpd->seekTo(intval($mpd->current_track_length * $seek_factor));
}

function getTrackProgress($mpd) {
	$progress = ($mpd->current_track_position / $mpd->current_track_length) * 100;
	echo $progress;
	//echo $mpd->current_track_position;
}

function controlVolumeUp($mpd) {
	$mpd->AdjustVolume(5);
}

function controlVolumeDown($mpd) {
	$mpd->AdjustVolume(-5);
}

function controlNext($mpd) {
	$mpd->Next();
}

function controlPrevious($mpd) {
	$mpd->Previous();
}

function controlToggle($mpd) {
	$mpd->Pause();
}

function getCurrentAlbum($mpd) {
	echo $mpd->playlist[$mpd->current_track_id]['Album'];
}

function getCurrentArtist($mpd) {
	echo $mpd->playlist[$mpd->current_track_id]['Artist'];
}

function getCurrentTitle($mpd) {
	echo $mpd->playlist[$mpd->current_track_id]['Title'];
}

function getPlaylist($mpd) {
	// copy relevant song information
	for ($index=0; $index < $mpd->playlist_count; $index++) {
		$playlist[] = array( $mpd->playlist[$index]['Title'],
		                     $mpd->playlist[$index]['Album'],
		                     $mpd->playlist[$index]['Artist']);
	}

	// add current playing track id and encode everything as a JSON string
	echo json_encode(array($mpd->current_track_id, $playlist));
}

function getPlaylistSize($mpd) {
	echo $mpd->playlist_count;
}

function playSong($mpd, $song) {
	$mpd->SkipTo($song);
}



///////////////////////////////////////
//             L O G I C             //
///////////////////////////////////////

// connect to server
$mpd = new mpd($mpd_host, $mpd_port);

// check connection
if ( $mpd->connected == FALSE )
	echo "Connection error: " . $mpd->errStr;   

// invoke the requested function
call_user_func($_GET["func"], $mpd, $_GET["params"]);
?>
