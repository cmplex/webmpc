# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $("#search_submit_button").button(
  ).click (e) ->
    data = needle: $("#searchbox").val()

    $("section").load "/search/results", data, (e) ->
      $("#search_results").selectable filter: $("#search_results").children("li")


  $("#search_add_button").button(
  ).click (e) ->

    selection = new Array()
    $(".ui-selected").each (index) ->
      selection.push $(".search_result").index(this)

    data = selection: selection, needle: $("#searchbox").val()

    $.post "/mpd/addSelection", data
