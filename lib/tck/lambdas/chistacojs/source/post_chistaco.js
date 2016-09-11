/* Copyright 2016 The Cocktail Experience, S.L. */

module.exports = {
  call: function(request, conf, chistaco, callback) {
    var post_params = conf.aditional_params;

    post_params[ conf.chistaco_param_name ] = chistaco;

    console.log("POST " + conf.post_url);
    console.log(post_params);

    request(
      {
        url: conf.post_url,
        method: 'POST',
        json: post_params
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
