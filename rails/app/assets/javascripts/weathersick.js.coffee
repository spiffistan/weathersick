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
  Weathersick.citiesIndex = new Weathersick.Views.CitiesIndex()
  Weathersick.citiesRouter = new Weathersick.Routers.Cities()
  Backbone.history.start()
