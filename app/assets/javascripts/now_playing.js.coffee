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




  # style buttons and add click handlers
  $("#prev_button").button(
    text: false
    icons:
      primary: "ui-icon-seek-prev"
  ).click ->
    $.post "mpd/prev"

  $("#toggle_button").button(
    text: false
    icons:
      primary: "ui-icon-play"
  ).click (e) ->
    options = undefined

    if $(this).text() is "play"
      $.post "mpd/play", (e) ->
        options =
          label: "pause"
          icons:
            primary: "ui-icon-pause"
        $("#toggle_button").button "option", options
        return

    else
      $.post "mpd/pause", (e) ->
        options =
          label: "play"
          icons:
            primary: "ui-icon-play"
        $("#toggle_button").button "option", options
        return

  $("#next_button").button(
    text: false
    icons:
      primary: "ui-icon-seek-next"
  ).click (e) ->
    $.post "mpd/next"

  $("#voldown_button").button(
    text: false
    icons:
      primary: "ui-icon-minus"
  ).click (e) ->
    $.post "mpd/volDown"


  $("#volup_button").button(
    text: false
    icons:
      primary: "ui-icon-plus"
  ).click (e) ->
    $.post "mpd/volUp"

  $("#hype_button").button(
    text: false
    icons:
      primary: "ui-icon-heart"
  ).click (e) ->
    $.post "voting/hype"

  $("#hate_button").button(
    text: false
    icons:
      primary: "ui-icon-seek-end"
  ).click (e) ->
    $.post "voting/hate"

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
