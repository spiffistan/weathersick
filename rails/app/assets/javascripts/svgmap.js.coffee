class window.SVGMap
  
  renderFrontPage: ->

    width = 960
    height = 300
    scale = 100

    projection = d3.geo.winkel3().scale(scale)
      .translate([width / 2 - .5, height / 2 - .5])

    path = d3.geo.path().projection(projection)

    arc = d3.geo.greatArc().precision(1)

    graticule = d3.geo.graticule()

    svg = d3.select("#map-container").append("svg")
      .attr("width", width)
      .attr("height", height)

    circles = svg.append("g").attr("class", "circles")
    countries = svg.append("g").attr('id', 'countries')
    arcs = svg.append("g").attr("id", "arcs")

    svg.append("path")
      .datum(graticule.outline)
      .attr("class", "background")
      .attr("d", path)

    svg.selectAll(".graticule")
      .data(graticule.lines)
      .enter().append("path")
      .attr("class", "graticule")
      .attr("d", path)

    svg.append("path")
      .datum(graticule.outline)
      .attr("class", "foreground")
      .attr("d", path)

    d3.json "/world-countries.json", (error, collection) ->

      countries.selectAll("path")
        .data(collection.features)
        .enter().append("path")
        .attr('class', 'land')
        .attr("d", path)
        .attr "id", (d) ->
          d.properties.name
        .append("title")
        .text (d) ->
          d.properties.name

      ll = projection([10.0, 60.0])

      circles.append('svg:circle')
        .attr('cx', ll[0])
        .attr('cy', ll[1])
        .attr('r', 2)
        .attr('class', 'highlighted')

      links = [
        { 'source': [10.0, 60.0], 'target': [114.15769, 22.28552] },
        { 'source': [10.0, 60.0], 'target': [-74.0, 40.7] },
        { 'source': [10.0, 60.0], 'target': [-43.2, -22.9] },
        { 'source': [10.0, 60.0], 'target': [88, 22] },
      ]

      arcs.selectAll("path")
        .data(links)
        .enter().append("path")
        .attr("class", "flightpath")
        .attr "d", (d) ->
          path(arc(d))

  renderTinyMap: (el, lat, lon) ->

    width = 100
    height = 70
    scale = 20

    projection = d3.geo.kavrayskiy7().scale(scale)
      .translate([width / 2 - .5, height / 2 - .5])

    path = d3.geo.path().projection(projection)

    svg = d3.select(el).append("svg")
      .attr("width", width)
      .attr("height", height)

    countries = svg.append("g").attr('id', 'countries')
    circles = svg.append("g").attr("class", "circles")
    
    d3.json "/world-countries.json", (error, collection) ->

      ll = projection([lon, lat])

      circles.append('svg:circle')
        .attr('cx', ll[0])
        .attr('cy', ll[1])
        .attr('r', 1.7)
        .attr('class', 'highlighted')


      countries.selectAll("path")
        .data(collection.features)
        .enter().append("path")
        .attr('class', 'land')
        .attr("d", path)
        .attr "id", (d) ->
          d.properties.name
        .append("title")
        .text (d) ->
          d.properties.name

      countries.select("#Antarctica").remove() # We don't need to show this.



