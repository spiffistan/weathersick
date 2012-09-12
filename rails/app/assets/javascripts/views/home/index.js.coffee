class Weathersick.Views.HomeIndex extends Backbone.View

  el: $('#home-container')

  initialize: ->

  events:
    'click #search-submit': 'fetchFlights'

  fetchFlights: ->
    $('#logo').fadeOut(100)
    accelerateClouds(1, 0.2)
    $('#search-container').animate(top: 100, 500, ->
      Weathersick.flightsRouter.list()
      # TODO decelerate
      window.cloudSpeed = 0.01
    )
