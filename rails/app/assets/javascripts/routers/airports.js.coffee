class Weathersick.Routers.Airports extends Backbone.Router

  routes:
    'airports': 'list'

  list: =>
    airports = new Weathersick.Collections.Airports()

    airports.fetch
      success: ->
        list = new Weathersick.Views.AirportsIndex(model: airports)
        list.render()

