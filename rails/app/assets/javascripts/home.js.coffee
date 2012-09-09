# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ -> 

  $('.datepicker').datepicker()

  $('.flip').live 'click', (event) ->
    $(this).find('.card').addClass('flipped').mouseleave ->
      $(this).removeClass('flipped');
