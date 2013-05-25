<?php
	include('config.php');
	include('lib/mpd.class.php');

	// connect to mpd server
	$mpd = new mpd($mpd_host,$mpd_port);

	// check connection
	if ( $mpd->connected == FALSE ) {
		echo "Error Connecting: " . $mpd->errStr;	
	}

	$func = $_GET["func"];
	$song = $_GET["song"];

	// fetch and echo queried data
	switch($func) {
		case "getCurrentAlbum":
			echo $mpd->playlist[$mpd->current_track_id]['Album'];
			break;

		case "getCurrentArtist":
			echo $mpd->playlist[$mpd->current_track_id]['Artist'];
			break;

		case "getCurrentTitle":
			echo $mpd->playlist[$mpd->current_track_id]['Title'];
			break;

		case "controlPrevious":
			$mpd->Previous();
			echo 0;
			break;

		case "controlNext":
			$mpd->Next();
			echo 0;
			break;

		case "controlToggle":
			$mpd->Pause();
			echo 0;
			break;

		case "playSong":
			$mpd->SkipTo($song);
			echo 0;
			break;

	}
?>
