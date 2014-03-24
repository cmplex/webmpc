# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# Show the list of artists on page load
$(document).ready ->
  displayArtists() if location.pathname is "/browse"



# Helper procedure for adding an enqueue button to an album entry
addEnqueueAlbumButtonTo = (element) ->
  # Add enqueue button only when the control menu has content
  # so we can assume the user is allowed to manage the MPD
  if $("menu a").text()
    button = $('<td>+</td>')
    button.click ->
      $(this).fadeTo "fast", 0.4
      $(this).fadeTo "fast", 1.0
      album = $(this).parent().text()
      album = album.substring 0, album.length - 1
      $.post 'mpd/addAlbum', album: album
    element.append button
  else element.append $('<td></td>')



# Helper procedure for adding an enqueue button to an artist entry
addEnqueueArtistButtonTo = (element) ->
  # Add enqueue button only when the control menu has content
  # so we can assume the user is allowed to manage the MPD
  if $("menu a").text()
    button = $('<td>+</td>')
    button.click ->
      $(this).fadeTo "fast", 0.4
      $(this).fadeTo "fast", 1.0
      artist = $(this).parent().text()
      artist = artist.substring 0, artist.length - 1
      $.post 'mpd/addArtist', artist: artist
    element.append button
  else element.append $('<td></td>')



# Helper procedure to render a list of all artists and set up onClick listeners
displayArtists = ->
  $.get "mpd/listArtists", (artists) ->
    # fade out and clear old list
    $("section").fadeOut "fast"
    $("section").empty()
    index = -1
    while ++index < artists.length
      $("section").append "<div id=\"artist" + index + "\" class=\"browselist_elem\">"
      $("#artist" + index).append "<table><tr><td>" + artists[index] + "</td></tr></table>"

      # setup onClick event handler
      $("#artist" + index + " table tr td").mouseup displayAlbums

      # Add enqueue button
      addEnqueueArtistButtonTo $("#artist" + index + " table tr")

    # fade in the new list
    $("section").fadeIn "fast"


# Helper procedure to render a list of all albums by an artist and set up onClick listeners
displayAlbums = ->
  $.get "mpd/listAlbums", artist: $(this).text(), (albums) ->
    # fade out and clear old list
    $("section").fadeOut "fast"
    $("section").empty()

    # add back button
    $("section").append "<div id=\"back_button\" class=\"browselist_elem\">"
    $("#back_button").append "<div>&larr;</div></div>"
    $("#back_button").mouseup displayArtists

    # add albums to the list and setup onClick handlers
    index = -1
    while ++index < albums.length
      $("section").append "<div id=\"album" + index + "\" class=\"browselist_elem\"></div>"
      $("#album" + index).append "<table><tr><td>" + albums[index] + "</td></tr></table>"

      # Setup onClick event handler
      $("#album" + index + " table tr td").mouseup displaySongs

      # Add enqueue button
      addEnqueueAlbumButtonTo $("#album" + index + " table tr")

    # fade in the new list
    $("section").fadeIn "fast"



# Helper procedure to render a list of songs on an album and set up onClick listeners
displaySongs = ->
  $.get "mpd/listSongs", album: $(this).text(), (songs) ->
    # fade out and clear old list
    $("section").fadeOut "fast"
    $("section").empty()

    # add back button
    $("section").append "<div id=\"back_button\" class=\"browselist_elem\">"
    $("#back_button").append "<div>&larr;</div></div>"
    $("#back_button").mouseup displayArtists

    # add songs to the list and setup onClick event handlers
    index = 0
    while index < songs.length
      $("section").append "<div id=\"browse_song" + index + "\" class=\"browselist_elem\">"
      $("#browse_song" + index).append "<div class=\"songinfo title\">" + songs[index][0] + "</div>"
      $("#browse_song" + index).append "<div class=\"songinfo artist\">" + songs[index][2] + "</div>"
      $("#browse_song" + index).append "<div class=\"songinfo album\">" + songs[index][1] + "</div>"

      # show only the song title
      $("#browse_song" + index + " div").hide()
      $("#browse_song" + index + " div:first-child").show()

      # setup onClick event handler
      $("#browse_song" + index).mouseup onSongItemClick
      index++

    # fade in the new list
    $("section").fadeIn "fast"



# onClick event handler for song items
onSongItemClick = ->
  if $(this).data("clicked") is "true"
    # read songid from the hidden element and start playback
    clickedTitle = $(this).find(".title").text()
    clickedArtist = $(this).find(".artist").text()
    clickedAlbum = $(this).find(".album").text()
    $.post "mpd/addSong", title: clickedTitle, album: clickedAlbum, artist: clickedArtist

    $(this).fadeTo "fast", 0.4
    $(this).fadeTo "fast", 0.6
  else
    # remove "clicked" flag of other items, set it on the clicked one
    $(".browselist_elem").removeData "clicked"
    $(this).data "clicked", "true"

    # hide other song descriptions, show specific song description
    $(".browselist_elem div").hide()
    $(".browselist_elem div:first-child").show()
    $(this).children(".songinfo").fadeIn()
