class Weathersick.Views.HomeIndex extends Backbone.View

  el: $('#home-container')

  initialize: ->
    opts =
      lines: 17 
      length: 8 
      width: 6 
      radius: 28 
      corners: 1.0 
      rotate: 0 
      color: '#fff' 
      speed: 1 
      trail: 25 
      shadow: true 
      hwaccel: false
      className: 'spinner' 
      zIndex: 2e9 
      top: 'auto' 
      left: 'auto' 

    spinner = new Spinner(opts).spin(document.getElementById('spinner'))
    this

  events:
    'click #search-submit': 'randomCities'

  randomCities: ->
    $('#cities').fadeOut(100)
    $('#logo').fadeOut(100)
    $('#description').fadeOut(500)
    # accelerateClouds(1, 0.2)
    $('#search-container').animate(top: 100, 500, ->
      $('#spinner').fadeIn(100)
      # Weathersick.citiesRouter.list()
      params = $('#search-form').serializeArray()
      Weathersick.citiesRouter.niceNear(params)
      # TODO decelerate
      window.cloudSpeed = 0.01
    )
