class Weathersick.Routers.Airports extends Backbone.Router

  routes:
    'airports': 'list'

  list: =>
    airports = new Weathersick.Collections.Airports()

    airports.fetch
      success: ->
        console.log(airports.models)
        list = new Weathersick.Views.AirportsIndex(model: airports)
        list.render()

