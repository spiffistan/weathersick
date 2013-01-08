class Weathersick.Views.CitiesIndex extends Backbone.View

  template: JST['cities/index']
  el: $('#cities-container')
  container: '#cities'

  events:
    'click .show-flights': 'showFlights'

  initialize: ->
    @render

  render: =>
    content = @template(cities: @model.toJSON())
    $(@container).html(content).show 0, ->
      $('#cities-container').fadeIn 300
      $('#search-submit').text('More!')

  showFlights: (e) ->
    # $(@el).fadeOut(300)
    $(@el).fadeOut(300)
    clicked = $(e.currentTarget)
    params = $('#search-form').serializeArray()
    params.push { name: 'to', value: clicked.data('iata-code') }
    Weathersick.flightsRouter.list(params)
