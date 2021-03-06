/* Copyright 2016 The Cocktail Experience, S.L. */
module.exports = function(conf) {
  var module = {
        name: conf.name,
        conf: conf,
        call: function(request, callback) {
          request(conf.url, function (error, response, body) {
            if (!error && response.statusCode == 200) {
              var cheerio = require('cheerio'),
                  dom = cheerio.load(body);
              callback(null, dom('.post .oldlink').html());
            }
            else {
              callback(error, response.statusCode);
            }
          })
        }
      };
  return(module);
}
