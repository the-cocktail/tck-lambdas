/* Copyright 2016 The Cocktail Experience, S.L. */

module.exports = {
  call: function(request, conf, chistaco, callback) {
    request(
      {
        url: conf.url,
        method: 'POST',
        json: {
          chistaco: chistaco
        }
      },
      function (err, response, body) {
        if(err) {
          callback(null, body);
        } else {
          callback(err, response.statusCode);
        }
      });
  }
}
