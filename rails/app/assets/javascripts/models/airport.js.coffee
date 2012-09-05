class Weathersick.Models.Airport extends Backbone.Model

  code: ->
    @get(this.gps_code)
