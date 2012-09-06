window.Weathersick =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->

$(document).ready ->
  Weathersick.init()
  Weathersick.flightsRouter = new Weathersick.Routers.Flights()
  Backbone.history.start()
