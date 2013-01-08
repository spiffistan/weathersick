window.DEBUG = true

$(document).ready ->

  svgmap = new SVGMap()
  svgmap.renderFrontPage()

  if Detector.webgl # We have webgl, create some clouds!
    clouds = new Clouds()
    clouds.init()
    clouds.animate()

  $('.datepicker').datepicker({'format':'dd-M-yyyy','weekStart':'1'})

#  $('.flip').live 'click', (event) ->
#    $(this).find('.card').addClass('flipped').mouseleave ->
#      $(this).removeClass('flipped')

  spinneropts =
    lines: 12
    length: 2
    width: 2
    radius: 10
    corners: 1.0
    rotate: 0
    color: '#fff'
    speed: 1
    trail: 25
    shadow: false
    hwaccel: false
    className: 'spinner'
    zIndex: 2e9
    top: 'auto'
    left: 'auto'

  spinner = new Spinner(spinneropts).spin(document.getElementById('typeahead-spinner'))
  $('#typeahead-spinner').fadeOut(0)

  $('.typeahead').typeahead
    ajax:
      url: '/typeahead-multi.json'
      preDispatch: (query) ->
        # spinner.spin()
        $('#typeahead-spinner').fadeIn(100)
        return { query: query }
      preProcess: (data) ->
        $('#typeahead-spinner').fadeOut(100)
        data
    method: 'get'
    itemSelected: (item, val, text) ->
      $('.typeahead').val(val)
#    source: (query, process) ->
#      $.get '/airports/typeahead.json', query: query, (data) ->
#        names = (item.name for item in data)
#        process(names)
#    onselect: (obj) ->
#      $('.typeahead').val(obj.iata_code)
