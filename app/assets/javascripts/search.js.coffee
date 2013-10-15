# vim: tabstop=2 shiftwidth=2 expandtab
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# shared variables
needle = undefined
OPACITY = 0.4



# setup button actions when the page has finished loading
$(document).ready ->
  $("#submitbutton").click ->
    $(this).fadeTo "fast", OPACITY
    $("#searchresults").empty()
    needle = document.getElementById("searchbox").value

    # submit query, get search results
    $.get "mpd/search", needle: needle, (response) ->
      results = response
      index = 0

      while index < results.length
        # create search result entry
        $("#searchresults").append "<div id=\"result" + index + "\" class=\"result\">"

        # fill in song information
        $("#result" + index).append "<div class=\"songinfo title\">" + results[index][0] + "</div>"
        $("#result" + index).append "<div class=\"songinfo artist\">" + results[index][2] + "</div>"
        $("#result" + index).append "<div class=\"songinfo album\">" + results[index][1] + "</div>"
        $("#result" + index).data "index", index

        # show only the song title
        $("#result" + index + " div").hide()
        $("#result" + index + " div:first-child").fadeTo "slow", 1.0

        # set onClick event handler
        $("#result" + index).click onSearchResultClick
        index++

      $("#submitbutton").fadeTo "fast", 1.0

  $("#addallbutton").click ->
    # fade out
    $("#addallbutton").fadeTo "fast", OPACITY

    needle = document.getElementById("searchbox").value
    $.post "mpd/addAll", needle: needle, (response) ->
      # fade in
      $("#addallbutton").fadeTo "fast", 1.0



# onClick() event handler for search results
onSearchResultClick = ->
  if $(this).data("clicked") is "true"
    # read song's search result index from the hidden element and add it to the playlist
    index = parseInt($(this).data("index"))
    $.post "mpd/addResult", needle: needle, index: index

    $(this).fadeTo "fast", OPACITY
    $(this).fadeTo "fast", 0.6
  else
    # remove "clicked" flag from other items, set it on the clicked one
    $(".result").removeData "clicked"
    $(this).data "clicked", "true"

    # hide other song descriptions, show clicked song's description
    $(".result div").hide()
    $(".result div:first-child").show()
    $(this).children(".songinfo").fadeIn()
