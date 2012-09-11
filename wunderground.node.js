var http = require('http');

var databaseUrl = "admin:SorlandsCh1ps@weathersick-capasit-db-0.dotcloud.com:34301/weathersick";
var collections = ["wstations", "raw_weathers"];
var db = require("mongojs").connect(databaseUrl, collections);
var stations = [];
db.wstations.find(function(err, doc) { 
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
  
stations = stations[0];
http.globalAgent.maxSockets = 20;

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
stations.forEach( function(station) {
  //console.log("In station.");
  if (station.code !== undefined) {
    //console.log("Not undefined.");
    kaplow.forEach(function(date) {
      //console.log("Now in " + uri + date + '/q/' + station.code + ".json, fetching");
      http.get(uri + date + '/q/' + station.code + ".json", function(res) { 
        res.setEncoding('utf-8'); 
        //console.log("HTTP started");
        res.on('data', function(chunk) {
          var objname = "planner" + date.toString();
          //console.log(objname);
          try {
            doc = cons(objname, JSON.parse(JSON.minify(chunk)));
          } catch(err) {
            console.log("Error in " + station.code + ", " + err)
          }
          try {
          db.raw_weathers.update({"station":station.code},{$set:doc}, function(err) {
            
          });
        } catch (err) {
          console.log("Error in " + station.code + " " + objname + ", " + err)
        }
          //console.log("Got it.");
        }).on('error', function(e) {
          console.log("Got error: " + e.message);
      });
    });
    });
  } else { console.log ("Undefined"); }
});
//process.exit(1);

};
setTimeout(function () { setup() }, 5000);

(function(global){
	if (typeof global.JSON == "undefined" || !global.JSON) {
		global.JSON = {};
	}

	global.JSON.minify = function(json) {

		var tokenizer = /"|(\/\*)|(\*\/)|(\/\/)|\n|\r/g,
			in_string = false,
			in_multiline_comment = false,
			in_singleline_comment = false,
			tmp, tmp2, new_str = [], ns = 0, from = 0, lc, rc
		;

		tokenizer.lastIndex = 0;

		while (tmp = tokenizer.exec(json)) {
			lc = RegExp.leftContext;
			rc = RegExp.rightContext;
			if (!in_multiline_comment && !in_singleline_comment) {
				tmp2 = lc.substring(from);
				if (!in_string) {
					tmp2 = tmp2.replace(/(\n|\r|\s)*/g,"");
				}
				new_str[ns++] = tmp2;
			}
			from = tokenizer.lastIndex;

			if (tmp[0] == "\"" && !in_multiline_comment && !in_singleline_comment) {
				tmp2 = lc.match(/(\\)*$/);
				if (!in_string || !tmp2 || (tmp2[0].length % 2) == 0) {	// start of string with ", or unescaped " character found to end string
					in_string = !in_string;
				}
				from--; // include " character in next catch
				rc = json.substring(from);
			}
			else if (tmp[0] == "/*" && !in_string && !in_multiline_comment && !in_singleline_comment) {
				in_multiline_comment = true;
			}
			else if (tmp[0] == "*/" && !in_string && in_multiline_comment && !in_singleline_comment) {
				in_multiline_comment = false;
			}
			else if (tmp[0] == "//" && !in_string && !in_multiline_comment && !in_singleline_comment) {
				in_singleline_comment = true;
			}
			else if ((tmp[0] == "\n" || tmp[0] == "\r") && !in_string && !in_multiline_comment && in_singleline_comment) {
				in_singleline_comment = false;
			}
			else if (!in_multiline_comment && !in_singleline_comment && !(/\n|\r|\s/.test(tmp[0]))) {
				new_str[ns++] = tmp[0];
			}
		}
		new_str[ns++] = rc;
		return new_str.join("");
	};
})(this);
