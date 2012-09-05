class Weathersick.Views.AirportsIndex extends Backbone.View

  template: JST['airports/index']
  container: '#airports'

  initialize: ->
    @render

  render: ->
    $(@container).html(@template(airports: @model.toJSON()))
