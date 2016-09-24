/* Copyright 2016 The Cocktail Experience, S.L. */
module.exports = {
  lambda_version: '0.2.0',
  post_url: 'https://httpbin.org/post',
  chistaco_param_name: 'chistaco',
  aditional_params: {},
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
    },
    {
      param: 'chyton',
      name: 'Chyton',
      url: 'http://pagina-del-dia.euroresidentes.es/chiste-del-dia/gadget-chiste-del-dia.php?modo=2',
      xpath: '//td',
      index: 2
    }
  ]
}
