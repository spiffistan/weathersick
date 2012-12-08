class Weathersick.Views.HomeIndex extends Backbone.View

  el: $('#home-container')

  initialize: ->
    spinneropts =
      lines: 17
      length: 3
      width: 5
      radius: 28
      corners: 3.0
      rotate: 0
      color: '#fff'
      speed: 1.3
      trail: 15
      shadow: false
      hwaccel: false
      className: 'spinner'
      zIndex: 2e9
      top: 'auto'
      left: 'auto'

    spinner = new Spinner(spinneropts).spin(document.getElementById('spinner'))
    this

  events:
    'click #search-submit': 'randomCities'

  randomCities: ->
    # TODO: fade out a parent container
    $('#logo').fadeOut(100)
    $('#map-container').fadeOut(100)
    $('#description').fadeOut(100)
    $('#search-container').animate(top: 100, 500, ->
      $('#spinner').fadeIn(100)
      params = $('#search-form').serializeArray()
      Weathersick.citiesRouter.niceNear(params)
    )
