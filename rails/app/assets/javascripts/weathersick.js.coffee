window.Weathersick =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->

$(document).ready ->
  Weathersick.init()
  vent = _.extend({}, Backbone.Events);
  Weathersick.homeIndex = new Weathersick.Views.HomeIndex()
  Weathersick.flightsIndex = new Weathersick.Views.FlightsIndex()
  Weathersick.flightsRouter = new Weathersick.Routers.Flights()
  Backbone.history.start()
