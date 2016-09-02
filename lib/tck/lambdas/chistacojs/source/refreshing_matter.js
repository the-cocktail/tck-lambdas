/* Copyright 2016 The Cocktail Experience, S.L. */

module.exports = {
  call: function(request, conf, callback) {
    var url = conf.refreshing_matter.url;
    request(url, function (error, response, body) {
      if (!error && response.statusCode == 200) {
        var important_matters = JSON.parse(body)[ conf.refreshing_matter.key ],
            random_index = Math.floor(Math.random() * important_matters.length);
        callback(null, important_matters[ random_index ]);
      }
      else {
        callback(error, response.statusCode);
      }
    })
  }
}
