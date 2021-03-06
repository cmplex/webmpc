# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("a").click ->
    $(this).fadeTo "fast", 0.4
    $(this).fadeTo "fast", 1.0

  $("mark").delay(2000).fadeOut 1000

  $("#nav_song_button").click (e) ->
    e.preventDefault()
    window.location.href = "/now_playing"
    return false

  $("#nav_playlist_button").click (e) ->
    e.preventDefault()
    window.location.href = "/playlist"
    return false

  $("#nav_search_button").click (e) ->
    e.preventDefault()
    window.location.href = "/search"
    return false

  $("#nav_browse_button").click (e) ->
    e.preventDefault()
    window.location.href = "/browse"
    return false
