class Weathersick.Routers.Cities extends Backbone.Router

  routes:
    'cities': 'list'
    'paramtest/:params': 'niceNear'

  list: =>
    cities = new Weathersick.Collections.Cities()

    cities.fetch
      success: ->
        $('#spinner').fadeOut(300)
        list = new Weathersick.Views.CitiesIndex(model: cities)
        list.render()

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
