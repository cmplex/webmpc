# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  OPACITY = 0.4

  $("#prevbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpc/prev", ->
      # fade in
      $("#prevbutton").fadeTo "fast", 1.0


  $("#nextbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpc/next", ->
      # fade in
      $("#nextbutton").fadeTo "fast", 1.0


  $("#togglebutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpc/toggle", ->
      # fade in
      $("#togglebutton").fadeTo "fast", 1.0

  $("#minusbutton").click ->
      # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpc/volDown", ->
        # fade in
      $("#minusbutton").fadeTo "fast", 1.0


  $("#plusbutton").click ->
    # fade out
    $(this).fadeTo "fast", OPACITY
    $.post "mpc/volUp", ->
      # fade in
      $("#plusbutton").fadeTo "fast", 1.0


  $("#progressbar-container").click (e) ->
    # get x-position relative to progressbar-container
    xpos = e.pageX - @offsetLeft

    # x-pos / max-x - ratio
    seek_factor = xpos / $(this).width()
    $.post "mpc/seek", factor: seek_factor


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

  # setup timer that fetches current song information and updates the page
  UPDATE_INTERVAL = 500
  album = undefined
  artist = undefined
  title = undefined
  progress = undefined

  updateSongView = ->
    # update title
    $.get "mpc/currentTitle", (response) ->
      unless response is title
        title = response
        $("#title").hide()
        $("#title").html(response).fadeIn()

    # update artist
    $.get "mpc/currentArtist", (response) ->
      unless response is artist
        artist = response
        $("#artist").hide()
        $("#artist").html(response).fadeIn()

    # update album name & cover
    $.get "mpc/currentAlbum", (response) ->
      unless response is album
        album = response
        $("#album").hide()
        $("#album").html(response).fadeIn()

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

    # update progress bar
    $.get "mpc/currentProgress", (response) ->
      response = parseInt(response)
      unless response is progress
        progress = response
        $("#progressbar").width response + "%"

  # initialize view
  updateSongView()
  $("#songbutton").css opacity: 1.0

  # schedule update
  songview_updater = setInterval(updateSongView, UPDATE_INTERVAL)
