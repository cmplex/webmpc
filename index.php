<!DOCTYPE html>
<html>

	<head>
		<title>WebMPC</title>
		<link rel="stylesheet" type="text/css" href="style/stylesheet.css">		<!-- Main stylesheet -->
		<link rel="stylesheet" type="text/css" href="style/playlist.css">		<!-- Playlist stylesheet -->
		<link rel="stylesheet" type="text/css" href="style/songview.css">		<!-- Songview stylesheet -->

		<?php

			include('config.php');
			include('lib/mpd.class.php');
			$myMpd = new mpd($mpd_host,$mpd_port);

			if ( $myMpd->connected == FALSE ) {
				echo "Error Connecting: " . $myMpd->errStr;	
			}

			else

			{

				switch($_REQUEST[cmd])
				{
					case "prev":
						$myMpd->Previous();
						break;
					case "toggle":
						$myMpd->Pause();
						break;
					case "next":
						$myMpd->Next();
						break;
					default:
						break;
				}
		?>




		<script type="text/javascript" src="lib/jquery.js"></script>		<!-- JQuery -->
		<script type="text/javascript" src="frontend.js"></script>			<!-- Frontend behaviour -->

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
					<a href='<?php echo $_SERVER[PHP_SELF]."?cmd=prev";?>'>prev</a> | 
					<a href='<?php echo $_SERVER[PHP_SELF]."?cmd=toggle";?>'>toggle</a> | 
					<a href='<?php echo $_SERVER[PHP_SELF]."?cmd=next";?>'>next</a>
				</div>


				<div id="songdescr">
					<p id="title"></p>
					<p id="artist"></p>
					<p id="album"></p>
				</div>

				<br/><br/>

			</div>
			
			<!-- Playlist view -->
			<div class="modeview" id="playlistview">
				<br/>
				
				<div id="playlist">

					<br/>

				<?php
					foreach ($myMpd->playlist as $id => $entry) {
				?>

				<div class="playlist_elem">
					<div id="songdescr">
						<div>
						<?php
							if($entry == $myMpd->playlist[$myMpd->current_track_id]){
						?>
						<font color=#FFFFFF>
						<?php
							}
						?>
								<?php
									echo($entry['Title']);
								?>
							</div>

						<?php
							if($entry == $myMpd->playlist[$myMpd->current_track_id]){
						?>
						</font>
						<?php
							}
						?>


							<div>
								<?php
									echo($entry['Artist']);
								?>
							</div>
							<div>
								<?php
									echo($entry['Album']);
								?>
							</div>


						</div>

						<br/>

					</div>

					<br/>

							
					<?php
						}
					?>

	
				</div>

				<br/>

			</div>
		

			<!-- Search view
			<div class="modeview" id="searchview">

				
				<br/>
			</div>
-->
		</div>

		<?php



			}
		
		?>

	</body>

</html>
