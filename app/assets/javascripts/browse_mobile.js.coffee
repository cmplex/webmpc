# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# load artists
loadArtists = ->
  # TODO: implement POST usage differently
  data = none: 'none'

  $("#navartist").text "artist"
  $("#navalbum").text "album"

  $("#section").load "/browse/browse_artists", data, (e) ->
    $("#section").listview "refresh"
    addClickHandlers()
    return
  return


# load albums for specified artist
loadAlbums = (artist) ->
  data = artist: artist

  $("#navalbum").text "album"

  $("#navartist").text(artist)
  $("#navartist").click (e) ->
    e.preventDefault()
    loadAlbums $("#navartist").text()
    return false

  $("#section").load "/browse/browse_albums", data, (e) ->
    $("#section").listview "refresh"
    addClickHandlers()
    return
  return



# load songs for specified album
loadSongs = (album) ->
  data = album: album

  $("#navalbum").text(album)
  $("#navalbum").click (e) ->
    e.preventDefault()
    loadSongs $("#navalbum").text()

  $("#section").load "/browse/browse_songs", data, (e) ->
    $("#section").listview "refresh"
    addClickHandlers()
    return

  return


addClickHandlers = ->
 $("a[data-browsestage='artist']").click (e) ->
    e.preventDefault()
    loadAlbums $(this).text()
    return false

  $("a[data-browsestage='album']").click (e) ->
    e.preventDefault()
    if $(this).text() is "back"
      loadArtists()
    else
      loadSongs $(this).text()
    return false

  $("#navroot").click (e) ->
    e.preventDefault()
    loadArtists()
    return false

  return


if location.pathname is "/browse"
  $(document).bind "pageinit", ->
    setTimeout ->
      addClickHandlers()
    , 500
