# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
artist = undefined
album = undefined
title = undefined



$(document).ready ->
  $("#progressbar").click (e) ->
    # get x-position relative to progressbar-container
    xpos = e.pageX - @offsetLeft

    # x-pos / max-x - ratio
    seek_factor = xpos / $(this).width()
    $.post "mpd/seek", factor: seek_factor



updateAlbumCover = ->
  $.get "mpd/cover", artistname: artist, albumname: album, (url) ->
    albumimg = document.createElement("img")
    albumimg.src = url
    $("#albumart").html albumimg



updateSongInfo = ->
  $.get "mpd/song_info", (song) ->
    # update progress bar
    $("#progressbar span").width song.progress + "%"

    # if the song info changed, update the view
    if artist != song.artist or album != song.album or title != song.title
      # update the album art if necessary
      if artist != song.artist or album != song.album
        artist = song.artist
        album = song.album
        updateAlbumCover()

      # update the song information
      title = song.title
      $("#artist").html(artist).fadeIn()
      $("#album").html(album).fadeIn()
      $("#title").html(title).fadeIn()



if location.pathname is "/" or location.pathname is "/now_playing"
  # initialize the view
  updateSongInfo()

  # set recurring update timer
  setInterval updateSongInfo, 1000
