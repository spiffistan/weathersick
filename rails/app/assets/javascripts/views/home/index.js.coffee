class Weathersick.Views.HomeIndex extends Backbone.View

  el: $('#home-container')

  initialize: ->
    console.log('here')

  events:
    'click #search-submit': 'fetchFlights'

  fetchFlights: ->
    console.log('yabba')
    $('#logo').fadeOut(100)
    accelerateClouds(1, 0.5)
    $('#search-container').animate(top: 100, 300, ->
      Weathersick.flightsRouter.list()
    )
