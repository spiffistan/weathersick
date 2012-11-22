class Weathersick.Views.CitiesIndex extends Backbone.View

  template: JST['cities/index']
  container: '#cities'

  initialize: ->
    @render

  render: ->
    content = @template(cities: @model.toJSON())
    $(@container).html(content).show()
    $('#results-container').fadeIn(300)
