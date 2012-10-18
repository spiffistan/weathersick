class Weathersick.Routers.Cities extends Backbone.Router

  niceNear: (params) =>
    console.log(params)
    cities = new Weathersick.Collections.Cities()

    if(params)
      cities.fetch
        data: params
        success: ->
          $('#spinner').fadeOut(300)
          list = new Weathersick.Views.CitiesIndex(model: cities)
          list.render()
          cities.each (city) ->
            console.log(city)
            # XXX perhaps move
            flights = new Weathersick.Collections.Flights()
            flights.fetch
              data: 
                from: "OSL"
                to: "LHR"
                date_from: "08/10/2012"
                date_to: "10/10/2012"
                type: 1
                num_people: 1
              success: =>
                console.log(flights.at(0))
                console.log(flights.at(0).attributes.total_fare)
            
                $('#city-' + city.attributes._id + ' .fare').text('$' + flights.at(0).attributes.total_fare)
                # TODO populate flights
                

          
          
