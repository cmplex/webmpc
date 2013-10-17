# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  OPACITY = 0.4

  $("#prevbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpd/prev", ->
      # fade in
      $("#prevbutton").fadeTo "fast", 1.0


  $("#nextbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpd/next", ->
      # fade in
      $("#nextbutton").fadeTo "fast", 1.0


  $("#togglebutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpd/toggle", ->
      # fade in
      $("#togglebutton").fadeTo "fast", 1.0

  $("#minusbutton").click ->
      # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpd/volDown", ->
        # fade in
      $("#minusbutton").fadeTo "fast", 1.0


  $("#plusbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpd/volUp", ->
      # fade in
      $("#plusbutton").fadeTo "fast", 1.0


  $("#progressbar-container").click (e) ->
    # get x-position relative to progressbar-container
    xpos = e.pageX - @offsetLeft

    # x-pos / max-x - ratio
    seek_factor = xpos / $(this).width()
    $.post "mpd/seek", factor: seek_factor


  $("#nextvotebutton").click ->
    # fade out
    $("#nextvotebutton").fadeTo "fast", OPACITY
    $.post "vote/hate", clientid: localStorage.userid , ->
      # fade in
      $("#nextvotebutton").fadeTo "fast", 1.0


  $("#hypebutton").click ->
    # fade out
    $("#hypebutton").fadeTo "fast", OPACITY
    $.post "vote/hype", clientid: localStorage.userid , ->
      # fade in
      $("#hypebutton").fadeTo "fast", 1.0



# FIXME
# define update function for the album art
album = undefined
updateAlbumCover = ->
  unless album is $("#album").html
    album = $("#album").html

    # create img tag with appropriate src
    albumimg = document.createElement("img")
    albumimg.src = "covers/default.png"
    $("#albumart").html albumimg

    # check if cover exists
    imgurl = "covers/" + response + ".jpg"
    $.ajax
      url: imgurl
      type: "HEAD"
      success: ->
        # cover does exist
        albumimg.src = imgurl



# setup event listeners for MPD notifications
if location.pathname is "/" or location.pathname is "/now_playing"
  source = new EventSource("/mpd/events/now_playing")
  source.addEventListener "song", (e) ->
    data = JSON.parse(e.data)
    $("#artist").hide()
    $("#album").hide()
    $("#title").hide()
    $("#artist").html(data["artist"]).fadeIn()
    $("#album").html(data["album"]).fadeIn()
    $("#title").html(data["title"]).fadeIn()
    # TODO: automatically update album cover
    #updateAlbumCover()
  source.addEventListener "progress", (e) ->
    data = JSON.parse(e.data)
    $("#progressbar").width data["progress"] + "%"
