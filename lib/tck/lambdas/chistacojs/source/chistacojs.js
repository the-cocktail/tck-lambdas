/* Copyright 2016 The Cocktail Experience, S.L. */
var conf = require('./conf'),
    http = require('request'),
    post = require('./post_chistaco'),
    // Chistacojs modules
    refreshing_matter = require('./refreshing_matter'),
    chistescortos     = require('./chistescortos'),
    chyton            = require('./chyton');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  console.log('chistacojs lambda version', conf.lambda_version);
  var data = event.body;
  var chistacojs_param, chistacojs_module;
  if (data.module === undefined) {
    console.log('Unspecified "module", choosing a random one...');
    var idx = Math.floor(Math.random() * conf.modules.length);
    chistacojs_param = conf.modules[idx].param;
  } else {
    chistacojs_param = data.module;
  };

  switch(chistacojs_param) {
    case 'refreshing':
      chistacojs_module = refreshing_matter(conf.modules[0]);
      break;
    case 'chistescortos':
      chistacojs_module = chistescortos(conf.modules[1]);
      break;
    case 'chyton':
      chistacojs_module = chyton(conf.modules[2]);
      break;
    default:
      context.fail('module: not found');
      return;
  }

  console.log('Extracting chistaco from "' + chistacojs_module.name + '" module...');
  chistacojs_module.call(http, function(err, chistaco) {
    if (err) {
      console.log(err, err.stack);
      context.fail(err);
    } else {
      console.log("Received: " + chistaco);
      post.call(http, conf, chistaco, function(err, data) {
        if (err) {
          console.log(err, err.stack);
          context.fail(err);
        } else {
          console.log("Response: " + data);
          context.succeed(0);
        }
      });
    }
  });
};
