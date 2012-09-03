class App.Airport extends Spine.Model

  @configure 'Airport', 'loc', 'continent', 'iso_country', 'iso_region', 'name'
  @extend Spine.Model.Ajax

  @near: (location) ->
    
    params = 
      data: { location: location }
      url: '/airports/near'
      processData: true

    json = @ajax().fetch(params)
    airport for airport in json
    #    airports = (new Airport(airport) for airport in @ajax().fetch(params))
