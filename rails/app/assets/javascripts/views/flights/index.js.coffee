class Weathersick.Views.FlightsIndex extends Backbone.View

  template: JST['flights/index']
  container: '#flights'

  initialize: ->
    @render

  render: ->
    $('#cities').slideLeft(100).hide()
    content = @template(flights: @model.toJSON())
    $(@container).hide().html(content).fadeIn(300)
