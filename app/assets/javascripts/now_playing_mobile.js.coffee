# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
artist = undefined
album = undefined
title = undefined
duration = undefined
elapsed = undefined


$(document).ready ->
  $("#progressbar").click (e) ->
    # get x-position relative to progressbar-container
    xpos = e.pageX - @offsetLeft

    # x-pos / max-x - ratio
    seek_factor = xpos / $(this).width()
    $.post "mpd/seek", factor: seek_factor



# define update function for the album art
updateAlbumCover = (artistname, albumname) ->
  $.get "mpd/cover", artistname: artistname, albumname: albumname, size: "extralarge", (url) ->
    albumimg = document.createElement("img")
    albumimg.src = url
    $("#albumart").html albumimg

# define progressbar update function
updateProgress = ->
  $("#progressbar span").width (elapsed / duration * 100) + "%"
  elapsed++

# define update function for the complete song information
updateSongInfo = ->
  $.get "mpd/song_info", (song) ->
    # update progress bar
    $("#progressbar span").width song.elapsed / song.duration * 100 + "%"

    # update global progress variables
    duration = song.duration
    elapsed = song.elapsed

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

      # automatically update album cover
      updateAlbumCover(song.artist, song.album)


if location.pathname is "/" or location.pathname is "/now_playing"
  # initialize the view
  updateSongInfo()

  # set recurring update timer
  setInterval updateSongInfo, 5000
  setInterval updateProgress, 1000
