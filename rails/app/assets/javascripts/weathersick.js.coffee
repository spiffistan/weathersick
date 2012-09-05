window.Weathersick =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->

$(document).ready ->
  Weathersick.init()
  Weathersick.airportsRouter = new Weathersick.Routers.Airports()
  Backbone.history.start()
