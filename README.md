TckLambdas
==========
_TckLambdas_ es una gema que facilita la utilización de una _AWS Lambda_ en el contexto de un proyecto _Ruby_ introduciendo en el mismo tareas de _Rake_ que realizan las **órdenes AWS** que debemos ejecutar habitualmente desde la _línea de comandos_.

Por ejemplo, para subir una mejora en el código de nuestra _lambda_ tenemos que, además de generar el _zip_ con la misma, ejecutar la siguiente orden:

    $ aws lambda update-function-code --function-name wadus --zip-file fileb://wadus.zip
    
Si hemos metido _TckLambdas_ en nuestro _Gemfile_ y hemos instalado en el mismo la _lambda wadus_ (``tcklambdas install wadus``), lanzaríamos la siguiente orden:

    $ rake tck_lambdas:wadus:upload_zip

Y si sólo tenemos esa _lambda_, creando el _alias_ necesario en nuestro _Rakefile_ (``task deploy_lambda: "tck_lambdas:wadus:upload_zip"``) podríamos lanzar simplemente:

    $ rake deploy_lambda

