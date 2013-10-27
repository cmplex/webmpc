# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Playlist update procedure
updatePlaylist = ->
  $('#section').load 'playlist/refresh_playlist', (r) ->
    $('#section').listview("refresh")



# Initialize the view and start periodic updates
if location.pathname is "/playlist"
  # initialize view
  updatePlaylist()

  # setup recurring update timer
  setInterval updatePlaylist, 1000
