class Weathersick.Views.CitiesIndex extends Backbone.View

  template: JST['cities/index']
  container: '#cities'

  initialize: ->
    @render

  render: ->
    content = @template(cities: @model.toJSON())
    $(@container).hide().html(content).fadeIn(300)
