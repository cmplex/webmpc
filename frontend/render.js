// vim: tabstop=3 shiftwidth=3 noexpandtab
// @author Cedric Haase


// content constants
var songbutton_text 			= "song";
var playlistbutton_text 	= "playlist";
var searchbutton_text 		= "search";
var browsebutton_text 		= "browse";

var prevbutton_text			= "prev";
var togglebutton_text		= "toggle";
var nextbutton_text			= "next";

var plusbutton_text			= "+";
var minusbutton_text			= "-";

var submitbutton_text		= "submit";



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
	$('#songview')			.append('<p									id="albumart">															</p>');
	$('#songview')			.append('<div								id="progressbar_container">										</div>');
	$('#songview')			.append('<div								id="controls">															</div>');
	$('#songview')			.append('<div								id="songdescr">														</div>');
	$('#songview')			.append('<div								id="volumecontrols">													</div>');

	$('#controls')			.append('<div class="controlbutton"	id="prevbutton">			' + prevbutton_text + '				</div>');
	$('#controls')			.append('<div class="controlbutton" id="togglebutton">		' + togglebutton_text + '			</div>');
	$('#controls')			.append('<div class="controlbutton" id="nextbutton">			' + nextbutton_text + '				</div>');

	$('#songdescr')		.append('<p									id="title">																</div>');
	$('#songdescr')		.append('<p									id="artist">															</div>');
	$('#songdescr')		.append('<p									id="album">																</div>');

	$('#volumecontrols')	.append('<div class="volumebutton"	id="minusbutton">		' + minusbutton_text + '				</div>');
	$('#volumecontrols')	.append('<div class="volumebutton"	id="plusbutton">		' + plusbutton_text + '					</div>');


	// add playlistview-constituents
	$('#playlistview')	.append('<div								id="playlist">															</div>');


	// add searchview-constituents
	$('#searchview')		.append('<div								id="inputcontainer">													</div>');
	$('#searchview')		.append('<div								id="searchresults">													</div>');

	$('#inputcontainer')	.append('<input type="text"			id="searchbox">														</input>');
	$('#inputcontainer')	.append('<div								id="submitbutton">		' + submitbutton_text + '			</div>');


	// add browse view members
	$('#browseview')		.append('<div 								id="browselist">														</div>');
});
