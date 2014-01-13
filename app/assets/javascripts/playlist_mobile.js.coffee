# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# setup event listeners for MPD notifications
if location.pathname is "/playlist"
  source = new EventSource("/mpd/events/playlist")

  # highlight currently playing song when it changes
  source.addEventListener "currentsong", (e) ->
    data = JSON.parse(e.data)

  # update the playlist when it changes
  source.addEventListener "playlist", (e) ->

    # update playlist items
    $('#section').load '/playlist/refresh_playlist', (r) ->
      $('#section').listview("refresh")
