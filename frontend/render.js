// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase

// media query

var mq = window.matchMedia( "only screen and (min-width: 1224px)" );

// content constants

// for desktops
if(mq.matches) {
	var songbutton_text			= "song";
	var playlistbutton_text		= "playlist";
	var searchbutton_text		= "search";
	var browsebutton_text		= "browse";

	var prevbutton_text			= "prev";
	var togglebutton_text		= "toggle";
	var nextbutton_text			= "next";

	var plusbutton_text			= "+";
	var minusbutton_text			= "-";

	var submitbutton_text		= "submit";

	var clearbutton_text			= "clear";

	var addallbutton_text		= "add all";
}
else {
	var songbutton_text			= "sng";
	var playlistbutton_text		= "pl";
	var searchbutton_text		= "sr";
	var browsebutton_text		= "brs";

	var prevbutton_text			= "pv";
	var togglebutton_text		= "tgl";
	var nextbutton_text			= "nxt";

	var plusbutton_text			= "+";
	var minusbutton_text			= "-";

	var submitbutton_text		= "go";

	var clearbutton_text			= "-";

	var addallbutton_text		= "+";
}



$(document).ready(function() {
	// add body
	$('html')				.append('<body></body>');


	// add modeswitcher & display-area
	$('body')				.append('<div 								id="modeswitcher">													</div>');
	$('body')				.append('<div								id="displayarea">														</div>');


	// add modebuttons
	$('#modeswitcher')	.append('<div class="modebutton" 	id="songbutton">			' + songbutton_text	+ '			</div>');
	$('#modeswitcher')	.append('<div class="modebutton"		id="playlistbutton">		' + playlistbutton_text + '		</div>');
	$('#modeswitcher')	.append('<div class="modebutton"		id="searchbutton">		' + searchbutton_text + '			</div>');
	$('#modeswitcher')	.append('<div class="modebutton"		id="browsebutton">		' + browsebutton_text + '			</div>');


	// add modeviews
	$('#displayarea')		.append('<div class="modeview"		id="songview">															</div>');
	$('#displayarea')		.append('<div class="modeview"		id="playlistview">													</div>');
	$('#displayarea')		.append('<div class="modeview"		id="searchview">														</div>');
	$('#displayarea')		.append('<div class="modeview"		id="browseview">														</div>');


	// add songview-constituents
	$('#songview')			.append('<div class="controlbar"		id="songcontrols">													</div>');
	$('#songview')			.append('<div class="viewsection"	id="songviewsection">												</div>');

	$('#songviewsection').append('<div								id="progressbar-container">										</div>');
	$('#songviewsection').append('<div								id="songdisplay">														</div>');

	$('#songcontrols')	.append('<div class="controlbutton"	id="prevbutton">			' + prevbutton_text + '				</div>');
	$('#songcontrols')	.append('<div class="controlbutton" id="togglebutton">		' + togglebutton_text + '			</div>');
	$('#songcontrols')	.append('<div class="controlbutton" id="nextbutton">			' + nextbutton_text + '				</div>');
	$('#songcontrols')	.append('<div class="controlbutton"	id="minusbutton">			' + minusbutton_text + '			</div>');
	$('#songcontrols')	.append('<div class="controlbutton"	id="plusbutton">			' + plusbutton_text + '				</div>');

	$('#songdisplay')		.append('<p									id="albumart">															</p>');
	$('#songdisplay')		.append('<div								id="albumart-overlay">												</div>');
	$('#songdisplay')		.append('<div								id="songdescr">														</div>');

	$('#songdescr')		.append('<p									id="title">																</div>');
	$('#songdescr')		.append('<p									id="artist">															</div>');
	$('#songdescr')		.append('<p									id="album">																</div>');

	$('#progressbar-container').append('<div						id="progressbar">														</div>');



	// add playlistview-constituents
	$('#playlistview')	.append('<div class="controlbar"		id="playlistcontrols">												</div>');
	$('#playlistview')	.append('<div class="viewsection"	id="playlistviewsection">											</div>');

	$('#playlistcontrols').append('<div class="controlbutton" id="clearbutton">		' + clearbutton_text + '				</div>');

	$('#playlistviewsection').append('<div							id="playlist">															</div>');


	// add searchview-constituents
	$('#searchview')		.append('<div class="controlbar"		id="searchcontrols">													</div>');
	$('#searchview')		.append('<div class="viewsection"	id="searchviewsection">												</div>');

	$('#searchcontrols')	.append('<input							id="searchbox">														</div>');
	$('#searchcontrols')	.append('<div class="controlbutton"	id="submitbutton">		' + submitbutton_text + '			</div>');
	$('#searchcontrols')	.append('<div class="controlbutton"	id="addallbutton">		' + addallbutton_text + '				</div>');

	$('#searchviewsection').append('<div							id="searchresults">													</div>');


	// add browse view members
	$('#browseview')		.append('<div class="controlbar"		id="browsecontrols">													</div>');
	$('#browseview')		.append('<div class="viewsection"	id="browseviewsection">												</div>');

	$('#browseviewsection').append('<div							id="browselist">														</div>');
});
