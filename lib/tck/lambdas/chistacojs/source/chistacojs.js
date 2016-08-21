/* Copyright 2016 The Cocktail Experience, S.L. */
var conf = require('./conf'),
    request = require('request'),
    refreshing_matter = require('./refreshing_matter');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  console.log('chistacojs lambda version', conf.lambda_version);

  console.log('Extracting chistaco from the refreshing_matter module');
  refreshing_matter.call(request, function(err, data) {
    if (err) {
      console.log(err, err.stack);
      context.fail(err);
    } else {
      console.log(data);
      context.succeed(0);
    }
  });
};
