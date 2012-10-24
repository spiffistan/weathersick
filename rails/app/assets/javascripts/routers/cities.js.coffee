class Weathersick.Routers.Cities extends Backbone.Router

  niceNear: (params) =>
    cities = new Weathersick.Collections.Cities()

    if(params)
      cities.fetch
        data: params
        success: ->
          $('#spinner').fadeOut(300)
          list = new Weathersick.Views.CitiesIndex(model: cities)
          list.render()
          f = params.shift().value
          cities.each (city) ->
            # XXX perhaps move
            airports = new Weathersick.Collections.Airports()
            airports.fetch
              data:
                location: city.attributes.lat + "," + city.attributes.lon
              success: =>
                t = airports.first().attributes.iata_code
                flights = new Weathersick.Collections.Flights()
                console.log(t)
                flights.fetch
                  data:
                    to: t
                    from: f
                    #date_from: "08/10/2012" # needs to be urldecoded, does not work atm
                    #date_to: "15/10/2012"
                    type: 1
                    adults: 1
                  success: =>
                    $('#city-' + city.attributes.city_id + ' .fare').text('$' + flights.at(0).attributes.total_fare)
                    $('#city-' + city.attributes.city_id + ' a').attr('href', flights.at(0).attributes.booking_link)
                    $('#city-' + city.attributes.city_id + ' a').attr("target", "_blank")
                      # TODO populate flights
                  error: =>
                    console.log("no flight :(")
                

          
          
