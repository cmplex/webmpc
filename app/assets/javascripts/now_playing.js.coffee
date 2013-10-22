# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("#progressbar").click (e) ->
    # get x-position relative to progressbar-container
    xpos = e.pageX - @offsetLeft

    # x-pos / max-x - ratio
    seek_factor = xpos / $(this).width()
    $.post "mpd/seek", factor: seek_factor



# FIXME
# define update function for the album art
#album = undefined
#updateAlbumCover = ->
#  unless album is $("#album").html
#    album = $("#album").html
#
#    # create img tag with appropriate src
#    albumimg = document.createElement("img")
#    albumimg.src = "covers/default.png"
#    $("#albumart").html albumimg
#
#    # check if cover exists
#    imgurl = "covers/" + response + ".jpg"
#    $.ajax
#      url: imgurl
#      type: "HEAD"
#      success: ->
#        # cover does exist
#        albumimg.src = imgurl

updateAlbumCover = (artistname, albumname) ->
  $.get "mpd/cover", artistname: artistname, albumname: albumname, (url) ->
    albumimg = document.createElement("img")
    albumimg.src = url
    $("#albumart").html albumimg



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
    updateAlbumCover(data["artist"], data["album"])
  source.addEventListener "progress", (e) ->
    data = JSON.parse(e.data)
    $("#progressbar span").width data["progress"] + "%"
