var http = require('http');
var fs = require('fs');

var databaseUrl = "admin:SorlandsCh1ps@weathersick-capasit-db-0.dotcloud.com:34301/weathersick";
var collections = ["wstations", "raw_weathers"];
var db = require("mongojs").connect(databaseUrl, collections);
var stations = [];

// The script assumes that raw_weathers is a collection of _remaining_ stations.
// We move from wstations to this, move to raw_weather_cache when things get slow.
// Then we remove those objects from raw_weathers so just the remaining codes are there.

db.raw_weathers.find({planner01010107:{$exists:false}}, function(err, doc) { 
  stations.push(doc);
});
var uri = "http://api.wunderground.com/api/eebf95c61da19812/planner_";

var kaplow = [];

var cons = function(name, value) {
  var doc = {};
  doc[name] = value;
  return doc
}

function setup () {

console.log(stations[0].length)
  

stations = stations[0];
http.globalAgent.maxSockets = 7;

for (i = 1; i<=365;i=i+7) {
  if (i >= 365) { break }
  d1 = new Date(2012, 0, i);
  if (i > 350) {
    d2 = new Date(2012, 0, i+8);
  } else {
    d2 = new Date(2012, 0, i+6);
  }
  month1 = d1.getMonth();
  month1 = month1 + 1;
  month1 = month1.toString();
  day1 = d1.getDate().toString();
  month2 = d2.getMonth();
  month2 = month2 + 1;
  month2 = month2.toString();
  day2 = d2.getDate().toString();
  if (month1.length !== 2) {
    month1 = "0" + month1;
  }
  if (day1.length !== 2) {
    day1 = "0" + day1;
  }
  if (month2.length !== 2) {
    month2 = "0" + month2;
  }
  if (day2.length !== 2) {
    day2 = "0" + day2;
  }
  kaplow.push(month1 + day1 + month2 + day2);
}
//kaplow = ['01010107', '01080114'];
//stations = [{code: 'AYGA' },{code: 'ZSYN' }];
console.log("Initializing data import");
setTimeout(function() { fetch() }, 2000);
}
function fetch() {
  var i = 0;
stations.forEach( function(station) {
  //console.log("In station.");
  if (station.station !== undefined) {
    //console.log("Not undefined.");
    kaplow.forEach(function(date) {
      //console.log("Now in " + uri + date + '/q/' + station.code + ".json, fetching");
      http.get(uri + date + '/q/' + station.station + ".json", function(res) { 
        res.setEncoding('utf-8'); 
        //console.log("HTTP started");
        var output = '';
        var doc = {};
        var objname = '';
        res.on('data', function(chunk) {
          output += chunk;
        });
        res.on('end', function() {
          i++;
          if (i != 0 && i % 100 == 0) { console.log("Got " + i.toString()); }
          objname = "planner" + date.toString();
          try {
            doc = cons(objname, JSON.parse(output));
          } catch(err) {
            console.log("Error in " + station.station + " " + objname + ", " + err);
          }
          db.raw_weathers.update({"station":station.station},{$set:doc}, function(err) {
            
          });
        });
           
        }).on('error', function(e) {
          console.log("Got error in " + station.station + " " + date + " : " + e.message);
      });
    });
    
     
    } else { console.log ("Undefined"); }
  }); 
};
//process.exit(1);

setTimeout(function () { setup() }, 5000);