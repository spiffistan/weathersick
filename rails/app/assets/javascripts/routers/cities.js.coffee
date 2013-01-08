# TODO: refactor into methods to avoid callback spaghetti

class Weathersick.Routers.Cities extends Backbone.Router

  routes:
    'nice-near': 'niceNear'

  niceNear: (params) =>
    cities = new Weathersick.Collections.Cities()

    if(params)
      cities.fetch
        data: params
        success: ->
          $('#spinner').fadeOut(300)
          $('#loading-text').fadeOut(300)
          list = new Weathersick.Views.CitiesIndex(model: cities)
          list.render()
#          f = params.shift().value
          cities.each (city) ->
            svgmap = new SVGMap()
            svgmap.renderTinyMap('#city-' + city.attributes.city_id + ' .city-world-map', city.attributes.lat, city.attributes.lon)
            # XXX perhaps move
#            airports = new Weathersick.Collections.Airports()
#            airports.fetch
#              data:
#                location: city.attributes.lat + "," + city.attributes.lon
#              success: =>
#                t = airports.first().attributes.iata_code
#                flights = new Weathersick.Collections.Flights()
#
#                $('#city-' + city.attributes.city_id + ' .price').append('<div class="spinner">')
#
#                
#                spinneropts =
#                  lines: 17
#                  length: 6
#                  width: 4
#                  radius: 29
#                  corners: 1.0
#                  rotate: 0
#                  color: '#fff'
#                  speed: 0.5
#                  trail: 25
#                  shadow: false
#                  hwaccel: true
#                  className: 'spinner'
#                  zIndex: 2e9
#                  top: 'auto'
#                  left: 'auto'
#
#                $('#city-' + city.attributes.city_id + ' .price .spinner')
#
#                spinner = new Spinner(spinneropts).spin($('#city-' + city.attributes.city_id + ' .price .spinner').get(0))

                # TODO
#                flights.fetch
#                  data:
#                    to: t
#                    from: f
#                    #date_from: "08/10/2012" # needs to be urldecoded, does not work atm
#                    #date_to: "15/10/2012"
#                    type: 1
#                    adults: 1
#                  success: =>
#                    $('#city-' + city.attributes.city_id + ' .fare').text('$' + flights.at(0).attributes.total_fare)
#                    $('#city-' + city.attributes.city_id + ' a').attr('href', flights.at(0).attributes.booking_link)
#                    $('#city-' + city.attributes.city_id + ' a').attr("target", "_blank")
#                    $('#city-' + city.attributes.city_id + ' .price .spinner').remove()
#                      # TODO populate flights
#                  error: =>
#                    console.log("no flight :(")
