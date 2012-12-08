class Weathersick.Views.FlightsIndex extends Backbone.View

  template: JST['flights/index']
  el: $('#flights-container')
  container: '#flights'

  initialize: ->
    @render

  render: ->
    content = @template(flights: @model.toJSON())
    $(@container).hide().html(content).show 0, ->
      $('#flights-container').fadeIn 300
    
