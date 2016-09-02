/* Copyright 2016 The Cocktail Experience, S.L. */
var conf = require('./conf'),
    http = require('request'),
    post = require('post_chistaco'),
    refreshing_matter = require('./refreshing_matter');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  console.log('chistacojs lambda version', conf.lambda_version);

  console.log('Extracting chistaco from the refreshing_matter module');
  refreshing_matter.call(http, conf, function(err, chistaco) {
    if (err) {
      console.log(err, err.stack);
      context.fail(err);
    } else {
      console.log(chistaco);
      post.call(http, conf, chistaco, function(err, data) {
        if (err) {
          console.log(err, err.stack);
          context.fail(err);
        } else {
          console.log("Sending to " + conf.url + "...");
          console.log("Response: " + data);
          context.succeed(0);
        }
      });
    }
  });
};
