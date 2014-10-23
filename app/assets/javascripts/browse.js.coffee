# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


# load artists
loadArtists = ->
  $("#navartist").text "artist"
  $("#navalbum").text "album"

  $.post "/browse/browse_artists", (content) ->
    $("section").html content
    addClickHandlers()


# load albums for specified artist
loadAlbums = (artist) ->
  data = artist: artist

  $("#navalbum").text "album"

  $("#navartist").text(artist)
  $("#navartist").click (e) ->
    e.preventDefault()
    loadAlbums $("#navartist").text()
    return false

  $("section").load "/browse/browse_albums", data, (e) ->

    # add click handlers to add buttons
    $(".albumlist_item").each ->
      elem = $(this)
      addAlbumButton = elem.find(".browse_addalbum_button")
      albumName = elem.text()

      $(addAlbumButton).button(
        text: false
        icons:
          primary: "ui-icon-plus"
      ).click ->
        $.post "mpd/addAlbum",
        album: albumName

    addClickHandlers()



# load songs for specified album
loadSongs = (album) ->
  data = album: album

  $("#navalbum").text(album)
  $("#navalbum").click (e) ->
    e.preventDefault()
    loadSongs $("#navalbum").text()

  $("section").load "/browse/browse_songs", data, (e) ->

    artistName = $("#navartist").text()
    albumName = $("#navalbum").text()

    # add click handlers to add buttons
    $(".songlist_item").each ->
      elem = $(this)
      addSongButton = elem.find(".browse_addsong_button")
      songName = elem.text()

      $(addSongButton).button(
        text: false
        icons:
          primary: "ui-icon-plus"
      ).click ->
        $.post "mpd/addSong",
          artist: artistName
          album: albumName
          title: songName

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


if location.pathname is "/browse"
  $(document).ready ->
    loadArtists()
