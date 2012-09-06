class Weathersick.Routers.Flights extends Backbone.Router

  routes:
    'flights': 'list'

  list: =>
    flights = new Weathersick.Collections.Flights()

    flights.fetch
      success: ->
        console.log(flights)
        console.log(flights.results)
        list = new Weathersick.Views.FlightsIndex(model: flights)
        list.render()

