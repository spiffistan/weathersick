class Weathersick.Views.FlightsIndex extends Backbone.View

  template: JST['flights/index']
  container: '#flights'

  initialize: ->
    @render

  render: ->
    console.log(@model.toJSON())
    $(@container).html(@template(flights: @model.toJSON()))
    this
