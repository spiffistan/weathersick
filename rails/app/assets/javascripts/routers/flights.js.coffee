class Weathersick.Routers.Flights extends Backbone.Router

  routes:
    'flights': 'list'

  list: =>
    flights = new Weathersick.Collections.Flights()

    if(params)
      flights.fetch
        data: params
        success: ->
          list = new Weathersick.Views.FlightsIndex(model: flights)
          list.render()
