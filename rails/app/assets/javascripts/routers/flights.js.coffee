class Weathersick.Routers.Flights extends Backbone.Router

  routes:
    'flights': 'list'

  list: (params) ->
    if(params)
      $('#spinner').fadeIn(300)
      flights = new Weathersick.Collections.Flights()
      flights.fetch
        data: params
        success: ->
          list = new Weathersick.Views.FlightsIndex(model: flights)
          list.render()
          $('#spinner').fadeOut(300)

