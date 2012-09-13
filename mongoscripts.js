# Merge Vayama into airports
db.airports.find().forEach(function(doc) {doc.in_use = false});

var obj;
var prev_obj;
db.vayama.find().forEach(function(doc) {
  if (db.aps.find({'iata_code':doc.iataCode})) {
    var obj;
    obj = db.aps.findOne({'iata_code':doc.iataCode});
    obj.in_use = true;
    db.aps.save(obj);
    prev_obj = obj
  }})
  
  db.cities.find().forEach( function(x){db.citiesnew.insert(x)} );
  
  
  var ob;
  db.cities.find({airport_code:{$exists:true}}).forEach(function(doc) {
    ob = db.cities.findOne({'airport_code':{$exists:false},'CityId':doc.CityId});
    if (ob) { 
      ob.airport_code = doc.airport_code
      db.cities.save(ob)
    }
  });
  
  db.cities.find( { $and: [ { airport_code:{$exists:false} }, { CityRank: { $gt: 50 } } ] } )
  
  var foo = []; var i = 0; stations.forEach(function(station) { if (!db.raw_weathers.findOne({"station":station.code})) { foo.push(station) } i++;})
  
  var count = 0;
  var query;
  db.cities.find({airport_code:{$exists:false}}).forEach(function(doc) {
    query = db.aps.find({loc:{$near:doc.loc, $maxDistance: 0.1, }}).limit(1);
    if (query.count()) {count ++;}
  });
  
  var count = 0;
  var query;
  db.cities.find({airport_code:{$exists:false}}).forEach(function(doc) {
    query = db.aps.find({sphereloc:{$near:doc.sphereloc, $maxDistance: 5, }}).limit(1);
    if (query.count()) {count ++;}
  });
  
  
  db.airports.find().forEach(function(doc) {
    doc.sphereloc = [doc.longitude_deg, doc.latitude_deg];
    db.airports.save(doc);
  });
  
  db.cities.find({"sphereloc.a":null}).forEach(function(doc){ db.cities.update({$unset:{"sphereloc.a":1}}, doc) })
  
  use weathersick
  db.auth('admin','SorlandsCh1ps')
  
  var count = 0;
  var doc;
  var res;
  db.cities.find({wstation_code:null}).forEach(function(fjas) {
  res = db.runCommand({geoNear:"wstations", near:fjas.sphereloc, spherical:true, maxDistance:50/6378, num:1}).results;
  if (res.length !== 0) {
    fjas.wstation_code = res[0].obj.code;
    db.cities.save(fjas);
}
});

db.cities.find({CityName:{$exists:false}}).forEach(function(doc) {db.cities.remove(doc)})

db.runCommand({geoNear:"", near:[12.308200,61.356100], spherical:true, num:1}).results

var results = [];
for (var i = 0; i < arr.length - 1; i++) {
    if (results[i + 1] != results[i]) {
        results.push(results[i]);
    }
}

mongoimport -u root -p Tmd8ziuKGXneNoy54NeE -h weathersick-capasit-db-0.dotcloud.com --port 34301 --headerline -d weathersick -c wstations -type csv --stopOnError wstations.txt

db.cities.find({"wstation_code":/[A-Z0-9]+/}).forEach(function(doc) {
  ob = db.raw_weather_cache.findOne({'in_use':false, "station":doc['wstation_code']});
  if (ob) {
    doc.wstation_code = null;
    db.cities.save(doc);
  }
})

var codes = [];
db.raw_weather_cache.find().forEach(function(doc) {
  if (!db.airports_old.findOne({gps_code:doc['station']})) {
    doc.friend = false;
    db.raw_weather_cache.save(doc);
  }
})
  ob = db.airports_old.findOne({gps_code:doc['station']});
  if (ob) {

  } else { codes.push(doc['station']) }
});

  if (ob) {
     
    ob.station = doc.airport_code
    db.cities.save(ob)
  }
});

db.airports_old.find({}).forEach(function(doc) { db.wstations.update({code:doc.gps_code},{$set:{lat:doc.latitude_deg,lon:doc.longitude_deg}}) })
db.wstations.update({"lat":{"$exists":true}},{$set:{sphereloc:[lon,lat]}}, false, true)

db.wstations.find({"lat":{"$exists":true}}).forEach(function(doc) { doc.loc = [doc.lat, doc.lon]; db.wstations.save(doc) })









