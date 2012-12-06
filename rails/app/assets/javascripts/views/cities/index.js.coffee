class Weathersick.Views.CitiesIndex extends Backbone.View

  template: JST['cities/index']
  container: '#cities'

  el: $(@container)

  initialize: ->
    @render

  events:
    'click .show-flights': 'showFlights'

  render: =>
    content = @template(cities: @model.toJSON())
    $(@container).html(content).show()
    $('#results-container').fadeIn 300

  showFlights: =>
    console.log('clickety clack')
    $('#cities').slideLeft(100)
