# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ -> 

  $('.datepicker').datepicker({'format':'dd/mm/yyyy','weekStart':'1'});

  $('.flip').live 'click', (event) ->
    $(this).find('.card').addClass('flipped').mouseleave ->
      $(this).removeClass('flipped');

  $('.typeahead').typeahead 
  # ajax: '/airports/typeahead.json'
    ajax: '/typeahead-multi.json'
    method: 'get'
    itemSelected: (item, val, text) ->
      $('.typeahead').val(val)
#    source: (query, process) ->
#      $.get '/airports/typeahead.json', query: query, (data) ->
#        names = (item.name for item in data)
#        process(names)
#    onselect: (obj) ->
#      $('.typeahead').val(obj.iata_code)
