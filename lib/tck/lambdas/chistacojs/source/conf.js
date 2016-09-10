/* Copyright 2016 The Cocktail Experience, S.L. */
module.exports = {
  lambda_version: '0.2.0',
  post_url: 'https://httpbin.org/post',
  modules: [
    {
      param: 'refreshing',
      name: 'The Refreshing Matter',
      url: 'http://otaony.com:10003/tuits/EL%20EVENTO.json',
      key: 'OTRAS CUESTIONES IMPORTANTES'
    },
    {
      param: 'chistescortos',
      name: "ChistesCortos.eu",
      url: 'http://www.chistescortos.eu/random',
      selector: '.post .oldlink'
    }
  ]
}
