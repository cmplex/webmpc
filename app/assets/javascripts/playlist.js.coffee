# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
old_playlist = []
old_index = undefined



# onClick event handler for remove buttons
onRemoveButtonClick = ->
  $(this).fadeTo 'fast', 0.4
  $(this).fadeTo 'fast', 1.0
  $.post 'mpd/remove/' + $(this).parents('.playlist_elem').data 'number'


# onClick event handler for playlist items
onPlaylistItemClick = ->
  container = $(this).parents '.playlist_elem'
  if container.data("clicked") is "true"
    # read songid from attached data and start playback
    $.post "mpd/play", number: container.data 'number'
  else
    # remove "clicked" flag of other items, set it on the clicked one
    $(".playlist_elem").removeData "clicked"
    container.data "clicked", "true"

    # hide other song descriptions, show specific song description
    $(".playlist_elem div").hide()
    container.children(".songinfo").fadeIn()


# helper procedure for adding a remove button
addRemoveButtonTo = (element) ->
  # add remove button only when the control menu has content
  # so we can assume the user is allowed to manage the MPD
  if $("menu a").text()
    button = $('<td>x</td>')
    button.click onRemoveButtonClick
    element.append button
  else
    element.append $('<td></td>')


# main update procedure
updatePlaylist = ->
  $.get 'mpd/playlist', (data) ->
    # update playlist items
    songs = data.songs
    index = -1
    console.log 'index: ' + data.index
    while ++index < Math.max(songs.length, old_playlist.length)
      # add items if the new playlist is longer
      if index >= old_playlist.length
        # create playlist entry
        $("section").append '<div id="song' + index + '" class="playlist_elem">'

        # fill in song information
        $("#song" + index).append '<table><tr><td class="songinfo title">' + songs[index].title + '</td></tr></table>'
        $("#song" + index).append '<div class="songinfo artist">' + songs[index].artist + '</div>'
        $("#song" + index).append '<div class="songinfo album">' + songs[index].album + '</div>'

        # show only the song title
        $("#song" + index + " div").hide()

        # add remove button
        addRemoveButtonTo $("#song" + index + " table tr")

        # set onClick event handler
        $("#song" + index + " .title").mouseup onPlaylistItemClick
        $("#song" + index + " div").mouseup onPlaylistItemClick

        # attach song index
        $("#song" + index).data 'number', index

        continue

      # remove items if the new playlist is shorter
      if index >= songs.length
        $("#song" + index).remove()
        continue

      # update entries that have changed
      if songs[index].title isnt old_playlist[index].title or songs[index].artist isnt old_playlist[index].artist or songs[index].album isnt old_playlist[index].album
        # update song info
        $("#song" + index + " .title").text songs[index].title
        $("#song" + index + " .artist").text songs[index].artist
        $("#song" + index + " .album").text songs[index].album

    # update playlist state variable
    old_playlist = songs

    # highlight currently playing song when it changes
    if old_index isnt data.index
      $(".playlist_elem").fadeTo "fast", 0.4
      $("#song" + data.index).fadeTo "fast", 1.0

      # update index state variable
      old_index = data.index



if location.pathname is "/playlist"
  # initialize view
  updatePlaylist()

  # setup recurring update timer
  setInterval updatePlaylist, 1000
