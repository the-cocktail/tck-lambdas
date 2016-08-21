/* Copyright 2016 The Cocktail Experience, S.L. */
var conf = require('./conf');
var refreshing = require('./refreshing_matter');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  console.log('chistacojs lambda version', conf.lambda_version);

  console.log('Extracting chistaco from the RefreshingMatter module:', refreshing.call());
  // if (err) {
  //   console.log(err, err.stack);
  //   context.fail(err);
  // } else {
  context.succeed(0);
  // }
};
