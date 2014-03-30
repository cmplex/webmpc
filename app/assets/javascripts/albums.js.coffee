# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# reset retrieve_covers

$(document).ready ->

  $("#album-reset-button").button(
  ).click (e) ->
    alert "Please be patient, this might take a while."
    $.post "albums/reset", (response) ->
      window.location.reload()
      alert response

  $("#album-retrieve-button").button(
  ).click (e) ->
    alert "Please be patient, this might take a while."
    $.post "albums/retrieve", (response) ->
      window.location.reload()
      alert response
