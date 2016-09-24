/* Copyright 2016 The Cocktail Experience, S.L. */
module.exports = function(conf) {
  var module = {
        name: conf.name,
        conf: conf,
        call: function(request, callback) {
          request(conf.url, function (error, response, body) {
            if (!error && response.statusCode == 200) {
              var important_matters = JSON.parse(body)[ conf.key ],
                  random_index = Math.floor(Math.random() * important_matters.length);
              callback(null, important_matters[ random_index ]);
            }
            else {
              callback(error, response.statusCode);
            }
          })
        }
      };
  return(module);
}
