window.Weathersick =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->

$(document).ready ->
  Weathersick.init()
  vent = _.extend({}, Backbone.Events);
  # TODO: refactor
  # NOTE: this is probably not neccessary:
  Weathersick.homeIndex = new Weathersick.Views.HomeIndex()
  Weathersick.citiesIndex = new Weathersick.Views.CitiesIndex()
  Weathersick.citiesRouter = new Weathersick.Routers.Cities()
  Weathersick.flightsRouter = new Weathersick.Routers.Flights()
  Backbone.history.start()
