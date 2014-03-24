# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("a").click ->
    $(this).fadeTo "fast", 0.4
    $(this).fadeTo "fast", 1.0

  $("mark").delay(2000).fadeOut 1000


  $("#nav_song_button").button(
    icons:
      primary: "ui-icon-play"
  ).click (e) ->
    window.location.href = "/now_playing"


  $("#nav_playlist_button").button(
    icons:
      primary: "ui-icon-note"
  ).click (e) ->
    window.location.href = "/playlist"


  $("#nav_search_button").button(
    icons:
      primary: "ui-icon-search"
  ).click (e) ->
    window.location.href = "/search"

  $("#nav_browse_button").button(
    icons:
      primary: "ui-icon-folder-open"
  ).click (e) ->
    window.location.href = "/browse"

  $("#nav_users_button").button(
    icons:
      primary: "ui-icon-person"
  ).click (e) ->
    window.location.href = "/users/edit"

  $("#nav_settings_button").button(
    icons:
      primary: "ui-icon-gear"
  ).click (e) ->
    window.location.href = "/settings"

  $("#nav_user_button").button(
    icons:
      primary: "ui-icon-person"
  ).click (e) ->
    window.location.href = "/users/edit"

  $("#nav_logout_button").button(
    icons:
      primary: "ui-icon-key"
  ).click (e) ->
    $.ajax
      url: "/users/sign_out"
      type: "DELETE"
      success: (result) ->
        window.location.href = "/"

  $("#nav_login_button").button(
    icons:
      primary: "ui-icon-key"
  ).click (e) ->
    window.location.href = "/users/sign_in"
