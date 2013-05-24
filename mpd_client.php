<?php
	include('config.php');
	include('lib/mpd.class.php');

	// connect to mpd server
	$mpd = new mpd($mpd_host,$mpd_port);

	// check connection
	if ( $mpd->connected == FALSE ) {
		echo "Error Connecting: " . $mpd->errStr;	
	}

	// fetch and echo queried data
	switch($_GET["func"]) {
		case "getCurrentAlbum":
			echo $mpd->playlist[$mpd->current_track_id]['Album'];
			break;

		case "getCurrentArtist":
			echo $mpd->playlist[$mpd->current_track_id]['Artist'];
			break;

		case "getCurrentTitle":
			echo $mpd->playlist[$mpd->current_track_id]['Title'];
			break;
	}
?>