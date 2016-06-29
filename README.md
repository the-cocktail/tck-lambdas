TckLambdas
==========
_TckLambdas_ es una gema que facilita la utilización de una _AWS Lambda_ en el contexto de un proyecto _Ruby_ introduciendo en el mismo tareas de _Rake_ que realizan las **órdenes AWS** que debemos ejecutar habitualmente desde la _línea de comandos_.

Por ejemplo, para subir una mejora en el código de nuestra _lambda_ tenemos que, además de generar el _zip_ con la misma, ejecutar la siguiente orden:

    $ aws lambda update-function-code --function-name wadus --zip-file fileb://wadus.zip
    
Si hemos metido _TckLambdas_ en nuestro _Gemfile_ y hemos instalado en el mismo la _lambda wadus_ (``tck_lambdas install wadus``), lanzaríamos la siguiente orden:

    $ rake tck_lambdas:wadus:upload_zip

Y si sólo tenemos esa _lambda_, creando el _alias_ necesario en nuestro _Rakefile_ (``task deploy_lambda: "tck_lambdas:wadus:upload_zip"``) podríamos lanzar simplemente:

    $ rake deploy_lambda

Ejemplo de Uso
---
Vamos a meter un _formulario de contacto_ en nuestro proyecto y queremos usar la *lambda contact_form*. Instalamos la gema y dicha _lambda_:

    $ echo "gem 'tck-lambdas'" >> Gemfile
    $ bundle
    $ tck_lambdas install contact_form
    => tck_lambdas/contact_form/ created with the lambda sources & tests.
    => task/tck_lambdas/contact_form.rake created with common tasks.
    => .tck_lambdas.yml created with the contact_form lambda conf.
    

Tal y como nos avisa ha creado en la raiz del proyecto el fichero *.tck_lambdas.yml* con el siguiente contenido:

    contact_form:
      name: my_project_contact_form

Debemos cambiar ``my_project_contact_form`` por el nombre de nuestra lambda (de momento la creación de la lambda debe realizarse con la consola web de AWS Lambda con los recursos mínimos).
