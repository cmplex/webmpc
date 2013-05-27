<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>WebMPC</title>
		<link rel="stylesheet" type="text/css" href="style/stylesheet.css">		<!-- Main stylesheet -->
		<link rel="stylesheet" type="text/css" href="style/playlist.css">		<!-- Playlist stylesheet -->
		<link rel="stylesheet" type="text/css" href="style/songview.css">		<!-- Songview stylesheet -->
		<script type="text/javascript" src="lib/jquery.js"></script>		<!-- JQuery -->
		<script type="text/javascript" src="frontend/frontend.js"></script>			<!-- Frontend behaviour -->
		<script type="text/javascript" src="frontend/song_control.js"></script>
		<script type="text/javascript" src="frontend/playlist_control.js"></script>
	</head>

	<body>
		<div id="modeswitcher">
			<div class="modebutton" id="songbutton">song</div>
			<div class="modebutton" id="playlistbutton">playlist</div>
		</div>

		<br/>

		<!-- Display Area -->
		<div id="displayarea">

			<!-- Song view -->
			<div class="modeview" id="songview">
				<br/>
				<p id="albumart"></p>
				<br/>
				<div id="controls">
					<div class="controlbutton" id="prevbutton">prev</div>
					<div class="controlbutton" id="togglebutton">toggle</div>
					<div class="controlbutton" id="nextbutton">next	</div>
				</div>
				<br/>
				<div id="songdescr">
					<p id="title"></p>
					<p id="artist"></p>
					<p id="album"></p>
				</div>
				<br/><br/>
			</div>
			
			<!-- Playlist view -->
			<div class="modeview" id="playlistview">
				<div id="playlist">
			</div>

			<!-- Search view
			<div class="modeview" id="searchview">
				<br/>
			</div>
            -->
		</div>
	</body>
</html>
