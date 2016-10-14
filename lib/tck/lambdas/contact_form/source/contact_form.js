/* Copyright 2016 The Cocktail Experience, S.L. */
var AWS = require('aws-sdk');
var ses = new AWS.SES({apiVersion: '2010-12-01'});
var conf = require('./conf');
var utils = require('./utils');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));
  var data = event.body;

  if (!data.domain) { context.fail('domain: empty'); return; }

  var domain = conf.domains[data.domain];

  if (!domain) { context.fail('domain: not found'); return; }

  console.log(domain.emailAddress);

  if (!data.email) { context.fail('email: empty'); return; }
  if (!data.message || data.message === '') { context.fail('message: empty'); return; }

  var email = unescape(data.email);
  if (!utils.validateEmail(email)) { context.fail('email: format'); return; }

  var messageParts = [];

  if (data.name) messageParts.push("Name: " + data.name);
  if (data.company) messageParts.push("Company: " + data.company);
  if (data.phone) messageParts.push("Phone: " + data.phone);
  messageParts.push("Email: " + data.email);
  messageParts.push("\r\n" + data.message);

  var params = {
    Destination: {
      ToAddresses: [ domain.emailAddress ],
      BccAddresses: [ "fernando.gs@gmail.com" ]
    },
    Message: {
      Body: { Text: { Data: messageParts.join("\r\n"), Charset: 'UTF-8' } },
      Subject: { Data: domain.emailSubject, Charset: 'UTF-8' }
    },
    Source: domain.emailAddress,
    ReplyToAddresses: [ email ]
  };

  if ((data.cc) && (data.cc == "1")) {
    params.Destination.CcAddresses = [ data.email ];
  }

  ses.sendEmail(params, function(err, data) {
    if (err) {
      console.log(err, err.stack);
      context.fail(err);
    } else {
      console.log(data);
      context.succeed(0);
    }
  });
};
