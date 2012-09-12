class Weathersick.Routers.Cities extends Backbone.Router

  routes:
    'cities': 'list'

  list: =>
    cities = new Weathersick.Collections.Cities()

    cities.fetch
      success: ->
        $('#spinner').fadeOut(300)
        list = new Weathersick.Views.CitiesIndex(model: cities)
        list.render()

