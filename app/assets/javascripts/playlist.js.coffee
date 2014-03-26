# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
old_playlist = []
old_index = undefined

sort_start_index = undefined


# .equals method for object prototype
objects_equal = (object1, object2) ->

  # check for inherited methods and properties
  for propName of object1
    unless object1.hasOwnProperty(propName) is object2.hasOwnProperty(propName)
      return false

    # false if properties differ
    else return false  unless typeof object1[propName] is typeof object2[propName]

  # check property names
  for propName of object2
    unless object1.hasOwnProperty(propName) is object2.hasOwnProperty(propName)
      return false
    else return false  unless typeof object1[propName] is typeof object2[propName]

    # if the property is inherited, do not check any more
    continue  unless object1.hasOwnProperty(propName)


    # recurse into other objects and nested arrays
    if object1[propName] instanceof Array and object2[propName] instanceof Array
      return false  unless arrays_equal(object1[propName], object2[propName])
    else if object1[propName] instanceof Object and object2[propName] instanceof Object
      return false  unless objects_equal(object1[propName], object2[propName])
    # string and number comparison
    else return false  unless object1[propName] is object2[propName]

  # all checks passed
  true




# .equals method for array prototype
arrays_equal = (array1, array2) ->

  # if the other array is a falsy value, return
  return false unless array2

  # compare lengths
  return false unless array1.length is array2.length
  i = 0
  l = array1.length

  while i < l
    # check for nested arrays
    if array1[i] instanceof Array and array2[i] instanceof Array

      # recurse into nested arrays
      return false unless arrays_equal(array1[i], array2[i])

    # object comparison
    else if array1[i] instanceof Object and array2[i] instanceof Object
      return false unless arrays_equal(array1[i], array2[i])

    # check for different object instances with same values
    else return false unless array1[i] is array2[i]
    i++

  # all checks passed
  true



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
# TODO: DRY up
updatePlaylist = ->
  $.get 'mpd/playlist', (data) ->
    # update playlist items
    songs = data.songs

    if !arrays_equal(old_playlist, songs) or old_playlist is undefined
      $("section").load "playlist/refresh_playlist", ->

        # update playlist state variable
        old_playlist = songs

        # apply mode to playlist
        applyMode()

        # highlight currently playing song
        # waiting for callback
        $(".playlist_item").fadeTo "fast", 0.6
        $(".playlist_item").each (i) ->
          if $(".playlist_item").index(this) is data.index
            $(this).fadeTo "fast", 1.0

          # update index state variable
        old_index = data.index

    # highlight currently playing song when it changes
    # not waiting for playlist load callback here
    if old_index isnt data.index and old_index isnt undefined

      $(".playlist_item").fadeTo "fast", 0.6
      $(".playlist_item").each (i) ->
        if $(".playlist_item").index(this) is data.index
          $(this).fadeTo "fast", 1.0

      # update index state variable
      old_index = data.index


# switch playlist view to "select mode"
selectMode = ->
  $("#playlist_clear_button").show()
  $("#playlist_remove_button").show()

  # return playlist to pre-init state
  if $("#playlist").hasClass "ui-sortable"
    $("#playlist").sortable "destroy"

  # initialize playlist as selectable
  $("#playlist").selectable filter: $("#playlist").children("li")

  $("#playlist_clear_button").button(
  ).click (e) ->
    $.post "mpd/clear"

  $("#playlist_remove_button").button(
  ).click (e) ->

    selection = new Array()
    $(".ui-selected").each (index) ->
      selection.push $(".playlist_item").index(this)

    data = selection: selection

    $.post "/mpd/removeSelection", data


# switch playlist view to "move mode"
moveMode = ->
  $("#playlist_clear_button").hide()
  $("#playlist_remove_button").hide()

  # return playlist to pre-init state
  if $("#playlist").hasClass "ui-selectable"
    $("#playlist").selectable "destroy"

  # initialize playlist as sortable
  $("#playlist").sortable

    # sorting starts
    start: (e, ui) ->
      sort_start_index = $(".playlist_item").index(ui.item)

    # sorting ends
    stop: (e, ui) ->
      sort_end_index = $(".playlist_item").index(ui.item)

      # set off move command if start and end indexes differ
      if sort_start_index isnt sort_end_index
        data =
          from: sort_start_index
          to: sort_end_index
        $.post "mpd/move", data

    filter: $("#playlist").children("li")


# apply matching mode
applyMode = ->
    if $("#playlist_mode_button").text() is "move"
      selectMode()
    else
      moveMode()


$(document).ready ->
  if location.pathname is "/playlist"

    # initialize view
    updatePlaylist()

    # setup recurring update timer
    setInterval updatePlaylist, 1000

  # apply click handler to mode switcher button
  $("#playlist_mode_button").button(
  ).click (e) ->
    options = undefined

    if $(this).text() is "select"
      selectMode()
      options =
        label: "move"
    else
      moveMode()
      options =
        label: "select"

    $("#playlist_mode_button").button "option", options
    applyMode()


