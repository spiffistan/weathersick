
var width = 960,
height = 300,
scale = 100;

// var projection = d3.geo.kavrayskiy7().scale(scale)
var projection = d3.geo.winkel3().scale(scale)
    .translate([width / 2 - .5, height / 2 - .5]);

var path = d3.geo.path().projection(projection);

var arc = d3.geo.greatArc();

var graticule = d3.geo.graticule();

var svg = d3.select("#map-container").append("svg")
    .attr("width", width)
    .attr("height", height)

var countries = svg.append("g").attr('id', 'countries');
var map = svg.append("g").attr("class", "map");
    
var arcs = svg.append("g").attr("id", "arcs");

svg.append("path")
    .datum(graticule.outline)
    .attr("class", "background")
    .attr("d", path);

svg.selectAll(".graticule")
    .data(graticule.lines)
    .enter().append("path")
    .attr("class", "graticule")
    .attr("d", path);

svg.append("path")
    .datum(graticule.outline)
    .attr("class", "foreground")
    .attr("d", path);
    
/*
d3.json("/boundaries.json", function(error, collection) {
  svg.insert("path", ".graticule")
      .datum(collection)
      .attr("class", "boundary")
      .attr("d", path);
});
*/ 

var links = []

d3.json("/world-countries.json", function(error, collection) {
      countries.selectAll("path")
        .data(collection.features)
        .enter().append("path")
        .attr('class', 'land')
        .attr("d", path)
        .attr("id", function(d) { return d.properties.name; })
        .append("title")
        .text(function(d) { return d.properties.name; });

      var ll = projection([10.0, 60.0])
      map.append('svg:circle')
        .attr('cx', ll[0])
        .attr('cy', ll[1])
        .attr('r', 2)
        .attr('class', 'highlighted')

      var arc = d3.geo.greatArc().precision(1);

      var links = [
        { 'source': [10.0, 60.0], 'target': [114.15769, 22.28552] },
        { 'source': [10.0, 60.0], 'target': [-74.0, 40.7] },
        { 'source': [10.0, 60.0], 'target': [-43.2, -22.9] },
        { 'source': [10.0, 60.0], 'target': [88, 22] },
      ];

        arcs.selectAll("path")
          .data(links)
            .enter().append("path")
            .attr("class", "flightpath")
            .attr("d", function(d) { return path(arc(d)); });
});


