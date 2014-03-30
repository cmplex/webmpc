# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  # define pseudo-selector :textall for HTML5 text input types
  (($) ->
    types = "text search email password".split(" ")
    len = types.length
    $.expr[":"]["textall"] = (elem) ->
      type = elem.getAttribute("type")
      i = 0

      while i < len
        return true if type is types[i]
        i++
      false

    return
  ) jQuery

  # apply styles to all text-type inputs
  $(":textall").button().css
    font: "inherit"
    color: "inherit"
    "text-align": "left"
    outline: "none"
    cursor: "text"

  # apply generic styles to all button-type inputs
  $(":button").button()
  $(":submit").button()

  # hide all menus on click anywhere on the page
  $(document).click (e) ->
    $(".ui-menu").hide()


  $("mark").delay(2000).fadeOut 1000

  $("#settings-menu").menu().hide()

  # apply specific styles and click handlers to nav buttons
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
    window.location.href = "/users"


  $("#nav_settings_button").button(
    icons:
      primary: "ui-icon-gear"
  ).click (e) ->
    e.stopPropagation()
    $("#settings-menu").css(
      left: e.pageX
      top: e.pageY
    )
    $("#settings-menu").show()

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
