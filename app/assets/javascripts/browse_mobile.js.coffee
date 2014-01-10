# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  displayArtists() if location.pathname is "/browse"



displayArtists = ->
  $.get "mpd/listArtists", (artists) ->
    # fade out and clear old list
    $("#section").empty()
    index = 0
    while index < artists.length
      $("#section").append "<li id=\"artist" + index + "\" class=\"browselist_elem\">"
      $("#artist" + index).append "<div>" + artists[index] + "</div>"

      # setup onClick event handler
      $("#artist" + index).mouseup displayAlbums
      index++

    # fade in the new list

displayAlbums = ->
  $.get "mpd/listAlbums", artist: $(this).find("div").text() , (albums) ->
    # fade out and clear old list
    $("#section").fadeOut "fast"
    $("#section").empty()

    # add back button
    $("#section").append "<div id=\"back_button\" class=\"browselist_elem\">"
    $("#back_button").append "<div>&larr;</div></div>"
    $("#back_button").mouseup displayArtists

    # add albums to the list and setup onClick handlers
    index = 0
    while index < albums.length
      $("#section").append "<div id=\"album" + index + "\" class=\"browselist_elem\">"
      $("#album" + index).append "<div>" + albums[index] + "</div>"
      $("#album" + index).mouseup displaySongs
      index++

    # fade in the new list
    $("#section").fadeIn "fast"

displaySongs = ->
  $.get "mpd/listSongs", album: $(this).find("div").text() , (songs) ->
    # fade out and clear old list
    $("#section").fadeOut "fast"
    $("#section").empty()

    # add back button
    $("#section").append "<div id=\"back_button\" class=\"browselist_elem\">"
    $("#back_button").append "<div>&larr;</div></div>"
    $("#back_button").mouseup displayArtists

    # add songs to the list and setup onClick event handlers
    index = 0
    while index < songs.length
      $("#section").append "<div id=\"browse_song" + index + "\" class=\"browselist_elem\">"
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
    $("#section").fadeIn "fast"

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
