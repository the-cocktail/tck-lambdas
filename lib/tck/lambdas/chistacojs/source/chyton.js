/* Copyright 2016 The Cocktail Experience, S.L. */
/* inspired by Ardor's Chyton lambda(*)
(*) https://gist.github.com/andor-pierdelacabeza/31509208af7b65448b4d743ae6f11035 */
module.exports = function(conf) {
  var module = {
        name: conf.name,
        conf: conf,
        call: function(request, callback) {
          request(conf.url, function (error, response, body) {
            if (!error && response.statusCode == 200) {
              var xpath = require('xpath'),
                  dom = require('xmldom').DOMParser,
                  doc = new dom().parseFromString(body),
                  nodes = xpath.select(conf.xpath, doc);
              callback(null, nodes[conf.index].toString());
            }
            else {
              callback(error, response.statusCode);
            }
          })
        }
      };
  return(module);
}
