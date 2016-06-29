TckLambdas
==========
_TckLambdas_ es una _gema_ que facilita la utilización de una _AWS Lambda_ en el contexto de un proyecto _Ruby_ introduciendo en el mismo tareas de _Rake_ que realizan las **órdenes AWS** que debemos ejecutar habitualmente desde la _línea de comandos_.

Por ejemplo, si tenemos una _función lambda_ llamada **shine** y queremos subir una mejora en su código tendríamos que, por un lado generar el _zip_ con dicha mejora, y por otro actualizar el mismo en _AWS Lambda_ (con la función ``aws lambda update-function-code`` o a través de su consola web).
    
Si hemos instalado la gema _TckLambdas_ en nuestro proyecto y hemos indicado en que el mismo hace uso de la _lambda shine_ (``tck_lambdas use shine``), lanzaríamos la siguiente orden para crear el _zip_:

    $ rake tck_lambdas:shine:create_zip

Y esta para subir el mismo a _AWS Lambda_ (para _"desplegar"_ la mejora):

    $ rake tck_lambdas:shine:upload_zip

Si sólo tenemos esa _lambda_, creando el _alias_ necesario en nuestro _Rakefile_ (``task deploy_lambda: "tck_lambdas:shine:upload_zip"``) podríamos lanzar simplemente:

    $ rake deploy_lambda

Ejemplo de Uso
---
Vamos a meter un _formulario de contacto_ en nuestro **proyecto Amazing** y queremos usar la *lambda* llamada de forma genérica *contact_form*. Instalamos la _gema TckLambdas_ y he indicamos que nuestro proyecto hace uso de dicha _lambda_:

    $ echo "gem 'tck-lambdas'" >> Gemfile # Metemos la gema en nuestro Gemfile...
    $ bundle                              #  - la instalamos y...
    $ tck_lambdas use contact_form        #  - y usamos la lambda:
    => tck_lambdas/contact_form/ created with the lambda sources & tests.
    => task/tck_lambdas/contact_form.rake created with common tasks.
    => .tck_lambdas.yml created with the contact_form lambda conf.
    
Tal y como nos avisa ha creado, entre otras cosas, el fichero *.tck_lambdas.yml* con la configuración para nuestra función _lambda_ con el siguiente contenido:

    contact_form:
      function-name: tck_project_contact_form
      handler: tck_project_contact_form.handler
      timeout: 30
      memory-size: 128
      runtime: nodejs4.3
      role: lambda_contact_form_role
      description: Lambda to manage new submissions in this project's contact form

Todos los valores por defecto deberían ser válidos excepto el nombre de la función (_function-name_) y el de su manejador (_handler_), en los que tendremos que sustituir *tck_project* por el nombre de nuestro proyecto (quedándonos con *amazing_contact_form* y *amazing_contact_form.handler* respectivamente).

Con dichos cambios en nuestro *.tck_lambdas.yml* ejecutamos la siguiente tarea de _rake_:

    $ rake tck_lambdas:contact_form:create_lambda

Dicha orden nos creará, además de la función _lambda_ necesaria para el entorno de producción, otra terminada en *_test* para la ejecución de los tests de la misma.

Por lo tanto, si todo ha ido bien deberíamos poder lanzar los tests de nuestra _lambda_ con éxito:

    $ rake tck_lambdas:contact_form:test

