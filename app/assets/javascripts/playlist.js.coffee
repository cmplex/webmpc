# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
old_playlist = []



# onClick event handler for playlist items
onPlaylistItemClick = ->
  if $(this).data("clicked") is "true"
    # read songid from the hidden element and start playback
    songid = parseInt($(this).find(".songid").text())
    $.post "mpd/play", number: songid
  else
    # remove "clicked" flag of other items, set it on the clicked one
    $(".playlist_elem").removeData "clicked"
    $(this).data "clicked", "true"

    # hide other song descriptions, show specific song description
    $(".playlist_elem div").hide()
    $(".playlist_elem div:first-child").show()
    $(this).children(".songinfo").fadeIn()



# setup event listeners for MPD notifications
if location.pathname is "/playlist"
  source = new EventSource("/mpd/events/playlist")

  # highlight currently playing song when it changes
  source.addEventListener "currentsong", (e) ->
    data = JSON.parse(e.data)
    $(".playlist_elem").fadeTo "fast", 0.4
    $("#song" + data["number"]).fadeTo "fast", 1.0

  # update the playlist when it changes
  source.addEventListener "playlist", (e) ->
    playlist = JSON.parse(e.data)

    # update playlist items
    index = -1
    while ++index < Math.max(playlist.length, old_playlist.length)
      # add items if the new playlist is longer
      if index >= old_playlist.length
        # create playlist entry
        $("#playlistview").append "<div id=\"song" + index + "\" class=\"playlist_elem\">"

        # fill in song information
        $("#song" + index).append "<div class=\"songinfo title\">" + playlist[index]["title"] + "</div>"
        $("#song" + index).append "<div class=\"songinfo artist\">" + playlist[index]["artist"] + "</div>"
        $("#song" + index).append "<div class=\"songinfo album\">" + playlist[index]["album"] + "</div>"
        $("#song" + index).append "<div class=\"songid\">" + index + "</div>"

        # show only the song title
        $("#song" + index + " div").hide()
        $("#song" + index + " div:first-child").show()

        # set onClick event handler
        $("#song" + index).mouseup onPlaylistItemClick
        continue

      # remove items if the new playlist is shorter
      if index >= playlist.length
        $("#song" + index).remove()
        continue

      # update song information
      if playlist[index]["title"] isnt old_playlist[index]["title"] or playlist[index]["artist"] isnt old_playlist[index]["artist"] or playlist[index]["album"] isnt old_playlist[index]["album"]
        $("#song" + index + " .title").contents().replaceWith playlist[index]["title"]
        $("#song" + index + " .artist").contents().replaceWith playlist[index]["artist"]
        $("#song" + index + " .album").contents().replaceWith playlist[index]["album"]
        $("#song" + index + " .songid").contents().replaceWith "" + index

    # update playlist state variable
    old_playlist = playlist
