class App.Airports extends Spine.Controller
  # elements:
  #   '.items': items
  # 
  # events:
  #   'click .item': 'itemClick'

  constructor: ->
    super
    # ...
    #

  render: => 
    airports = Airport.near
    @html @view('airports/index')(airports: airports)
