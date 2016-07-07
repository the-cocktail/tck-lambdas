/* Copyright 2016 The Cocktail Experience, S.L. */
var AWS = require('aws-sdk');
var ses = new AWS.SES({apiVersion: '2010-12-01'});
var conf = require('./conf');
var utils = require('./utils');

exports.handler = function(event, context) {
  console.log('Received event:', JSON.stringify(event, null, 2));

  if (!event.domain) { context.fail('domain: empty'); return; }

  var domain = conf.domains[event.domain];

  if (!domain) { context.fail('domain: not found'); return; }

  console.log(domain.emailAddress);

  if (!event.email) { context.fail('email: empty'); return; }
  if (!event.message || event.message === '') { context.fail('message: empty'); return; }

  var email = unescape(event.email);
  if (!utils.validateEmail(email)) { context.fail('email: format'); return; }

  var messageParts = [];

  if (event.name) messageParts.push("Name: " + event.name);
  if (event.company) messageParts.push("Company: " + event.company);
  if (event.phone) messageParts.push("Phone: " + event.phone);
  messageParts.push("Email: " + event.email);
  messageParts.push("\r\n" + event.message);

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

  if ((event.cc) && (event.cc == "1")) {
    params.Destination.CcAddresses = [ event.email ];
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
