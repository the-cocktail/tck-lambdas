/* Copyright 2016 The Cocktail Experience, S.L. */

module.exports = {
  call: function(request, callback) {
    var url = 'http://otaony.com:10003/tuits/EL%20EVENTO.json';
    request(url, function (error, response, body) {
      if (!error && response.statusCode == 200) {
        var important_matters = JSON.parse(body)["OTRAS CUESTIONES IMPORTANTES"],
            random_index = Math.floor(Math.random() * important_matters.length);
        callback(null, important_matters[ random_index ]);
      }
      else {
        callback(error, response.statusCode);
      }
    })
  }
}
