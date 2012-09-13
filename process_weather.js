var kaplow = [];
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
db.raw_weather_cache.find({in_use:true}).forEach(function(doc) {
  var i = 0;
  for(i = 0; i < 52; i++) {
    var weather = {}, res, trip;
    res = doc['planner' + kaplow[i]];
    trip = res.trip;
    weather.week = i+1;
    weather.title = trip.title;1
    weather.station = doc.station;
    weather.airport_code = trip.airport_code;
    weather.date_start = trip.period_of_record.date_start.date.pretty;
    weather.date_end = trip.period_of_record.date_end.date.pretty;
    
    weather.high_min_c = parseInt(trip.temp_high.min.C);
    weather.high_avg_c = parseInt(trip.temp_high.avg.C);
    weather.high_max_c = parseInt(trip.temp_high.max.C);
    weather.high_min_f = parseInt(trip.temp_high.min.F);
    weather.high_avg_f = parseInt(trip.temp_high.avg.F);
    weather.high_max_f = parseInt(trip.temp_high.max.F);

    weather.low_min_c = parseInt(trip.temp_low.min.C);
    weather.low_avg_c = parseInt(trip.temp_low.avg.C);
    weather.low_max_c = parseInt(trip.temp_low.max.C);
    weather.low_min_f = parseInt(trip.temp_low.min.F);
    weather.low_avg_f = parseInt(trip.temp_low.avg.F);
    weather.low_max_f = parseInt(trip.temp_low.max.F);

    weather.precip_min_cm = parseFloat(trip.precip.min.cm);
    weather.precip_avg_cm = parseFloat(trip.precip.avg.cm);
    weather.precip_max_cm = parseFloat(trip.precip.max.cm);
    weather.precip_min_in = parseFloat(trip.precip.min.in);
    weather.precip_avg_in = parseFloat(trip.precip.avg.in);
    weather.precip_max_in = parseFloat(trip.precip.max.in);

    weather.dewpoint_high_min_c = parseInt(trip.dewpoint_high.min.C);
    weather.dewpoint_high_avg_c = parseInt(trip.dewpoint_high.avg.C);
    weather.dewpoint_high_max_c = parseInt(trip.dewpoint_high.max.C);
    weather.dewpoint_high_min_f = parseInt(trip.dewpoint_high.min.F);
    weather.dewpoint_high_avg_f = parseInt(trip.dewpoint_high.avg.F);
    weather.dewpoint_high_max_f = parseInt(trip.dewpoint_high.max.F);
    
    weather.dewpoint_low_min_c = parseInt(trip.dewpoint_low.min.C);
    weather.dewpoint_low_avg_c = parseInt(trip.dewpoint_low.avg.C);
    weather.dewpoint_low_max_c = parseInt(trip.dewpoint_low.max.C);
    weather.dewpoint_low_min_f = parseInt(trip.dewpoint_low.min.C);
    weather.dewpoint_low_avg_f = parseInt(trip.dewpoint_low.avg.C);
    weather.dewpoint_low_max_f = parseInt(trip.dewpoint_low.max.C);
    
    weather.cloud_cover = trip.cloud_cover.cond;

    weather.chance_temp_below_0 = parseInt(trip.chance_of.tempbelowfreezing.percentage);
    weather.chance_temp_0_16 = parseInt(trip.chance_of.tempoverfreezing.percentage);
    weather.chance_temp_16_32 = parseInt(trip.chance_of.tempoversixty.percentage);
    weather.chance_temp_over_32 = parseInt(trip.chance_of.tempoverninety.percentage);
    weather.chance_dewpoint_over_16 = parseInt(trip.chance_of.chanceofsultryday.percentage);
    weather.chance_dewpoint_over_21 = parseInt(trip.chance_of.chanceofhumidday.percentage);
    weather.chance_precip = parseInt(trip.chance_of.chanceofprecip.percentage);
    weather.chance_snow_ground = parseInt(trip.chance_of.chanceofsnowonground.percentage);
    weather.chance_rain_day = parseInt(trip.chance_of.chanceofrainday.percentage);
    weather.chance_snow_day = parseInt(trip.chance_of.chanceofsnowday.percentage);
    weather.chance_hail_day = parseInt(trip.chance_of.chanceofhailday.percentage);
    weather.chance_partly_cloudy_day = parseInt(trip.chance_of.chanceofpartlycloudyday.percentage);
    weather.chance_cloudy_day = parseInt(trip.chance_of.chanceofcloudyday.percentage);
    weather.chance_foggy_day = parseInt(trip.chance_of.chanceoffogday.percentage);
    weather.chance_thunder_day = parseInt(trip.chance_of.chanceofthunderday.percentage);
    weather.chance_tornado_day = parseInt(trip.chance_of.chanceoftornadoday.percentage);
    weather.chance_windy_day = parseInt(trip.chance_of.chanceofwindyday.percentage);
    weather.chance_sunny_cloudy_day = parseInt(trip.chance_of.chanceofsunnycloudyday.percentage);
    
    db.weathers.save(weather);
  }
})