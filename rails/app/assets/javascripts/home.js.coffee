# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

geosuccess = (position) ->
  $('input[name="location"]').val(position.coords.latitude + ',' + position.coords.longitude) 

geoerror = ->
  console.log('Unable to geocode location')
 

$ -> 

  $('.datepicker').datepicker()

  if (navigator.geolocation)
    navigator.geolocation.getCurrentPosition(geosuccess, geoerror)

  $('#search-submit').click (e) ->
    $('#search-results').empty()
    $.post '/nice-near.json',
      $('#search-form').serialize()
      (data) -> 
        # Should be type Place
        $.each data, ->
          $('#search-results').append('<div class="search-result">' + this.name + ', ' + this.country_code)
