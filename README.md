# Tck::Lambdas

_Tck::Lambdas_ es una _gema_ que facilita la utilización de una _AWS Lambda_ en el contexto de un proyecto _Ruby_ introduciendo en el mismo tareas de _Rake_ que realizan las **órdenes AWS** que debemos ejecutar habitualmente desde la _línea de comandos_.

Por ejemplo, si tenemos una _función lambda_ llamada **shine** y queremos subir una mejora en su código tendríamos que, por un lado generar el _zip_ con dicha mejora, y por otro actualizar el mismo en _AWS Lambda_ (con la función ``aws lambda update-function-code`` o a través de su consola web).
    
Si hemos instalado la gema _Tck::Lambdas_ en nuestro proyecto y hemos indicado que utilizamos la _lambda shine_ (bundle exec ``tck-lambdas use shine``), lanzaríamos la siguiente orden para crear el _zip_:

    $ rake lambdas:shine:create_zip

Y esta para subir dicho _zip_ a _AWS Lambda_ (para _"desplegar"_ la mejora):

    $ rake lambdas:shine:upload_zip

Si sólo tenemos esa _lambda_ en el proyecto, creando el _alias_ necesario en nuestro _Rakefile_ (``task deploy_lambda: "lambdas:shine:upload_zip"``) podríamos lanzar simplemente:

    $ rake deploy_lambda

Comandos de _tck-lambdas_
-------------------------

Si lanzamos su ayuda nos cuenta lo siguiente:

    $ tck-lambdas help
    Commands:
      tck-lambdas all             # List all AWS Lambdas currently available in tck-lambdas.
      tck-lambdas help [COMMAND]  # Describe available commands or one specific command
      tck-lambdas roles           # List current AWS IAM roles (running 'aws iam list-roles [...]').
      tck-lambdas use NAME        # Use the AWS Lambda function known as NAME at The Cocktail.
      tck-lambdas used            # List functions currently used by this project.

**GOTCHA**: Tenemos también el *indocumentado comando* ``tck-lambdas list``, que es un _alias_ de ``tck-lambdas used``, **NO** de ``tck-lambdas all`` :)

Caso de Uso: *lambda contact_form*
----------------------------------

Vamos a meter un _formulario de contacto_ en nuestro proyecto **Amazing** y queremos usar la *lambda contact_form*. Instalamos la _gema Tck::Lambdas_ y le indicamos que nuestro proyecto hace uso de la _lambda_ llamada *contact_form*:

    $ echo "gem 'tck-lambdas'" >> Gemfile      # Metemos la gema en nuestro Gemfile...
    $ bundle                                   #  - la instalamos...
    $ cp Rakefile Rakefile.orig                #  - nos guardamos nuestro Rakefile...
    $ tck-lambdas use contact_form             #  - y usamos la lambda:
    /usr/lib/ruby/gems/[...]/lib/tck/lambdas/contact_form
          create  Rakefile
          create  Gemfile.example
          create  .lambdas.yml
          create  lib/tasks/lambdas.rake
          create  lib/tck/lambdas/aws_function.rb
          create  lambdas/test.rb
          create  lambdas/contact_form
          create  lambdas/contact_form/source/conf.js
          create  lambdas/contact_form/source/contact_form.js
          create  lambdas/contact_form/source/utils.js
          create  lambdas/contact_form/test/failed/domain_empty.json
          create  lambdas/contact_form/test/failed/domain_not_found.json
          create  lambdas/contact_form/test/failed/email_empty.json
          create  lambdas/contact_form/test/failed/email_format.json
          create  lambdas/contact_form/test/failed/message_empty.json
          create  lambdas/contact_form/test/succeeded/basic.json
          create  lambdas/contact_form/test/succeeded/with_cc.json
    $
 
Tal y como nos avisa ha creado, entre otras cosas, el fichero *.lambdas.yml* con la configuración para nuestra función _lambda_ con el siguiente contenido:

    contact_form:
      function-name: project_name_contact_form
      handler: project_name_contact_form.handler
      timeout: 30
      memory-size: 128
      runtime: nodejs4.3
      role: lambda_contact_form_role
      description: Project-Name instance of the Tck's contact_form lambda

Todos los valores por defecto deberían ser válidos excepto el nombre de la función (_function-name_), su manejador (_handler_), y su rol (_role_).

En el nombre de la función y su manejador tenemos que sustituir *project_name* por el nombre de nuestro proyecto (quedándonos con *amazing_contact_form* y *amazing_contact_form.handler* respectivamente).

El rol tenemos que sustituirlo por **el _ARN_ completo** de un rol que tenga permisos para ejecutar los servicios que necesite nuestra _lambda_. El comando **tck-lambdas roles** nos devuelve los _ARN_ de los distintos roles que tenemos a nuestra disposición en _AWS Lambda_.

Con dichos cambios en nuestro *.lambdas.yml* ejecutamos la siguiente tarea de _rake_:

    $ rake lambdas:contact_form:create_lambda

Dicha orden nos creará, **además de la función _lambda_** necesaria para el entorno de producción, **otra con el mismo nombre terminada en *_test* para la ejecución de sus tests** (en nuestro ejemplo si lanzamos ``aws lambda list-functions`` deberíamos tener dos nuevas funciones llamadas *amazing_contact_form* y *amazing_contact_form_test*).

Por lo tanto, si todo ha ido bien deberíamos poder lanzar los tests de nuestra _lambda_ con éxito:

    $ rake lambdas:contact_form:test

Modificando una _lambda_
------------------------

El código de la _lambda_ lo tenemos dentro de *lambdas/contact_form/source* y para añadir una mejora al mismo debemos seguir los siguientes pasos de cara a desplegarla:

1. Escribir la mejora
2. Crear el _zip_:
  ``rake lambdas:contact_form:create_zip``
3. Subir el nuevo _zip_ a la _lambda_ de tests:
  ``rake lambdas:contact_form:upload_test``
4. Lanzar los tests:
  ``rake lambdas:contact_form:test``
  (...volviendo al primer paso hasta que pasen)
5. Actualizar la _lambda_ de producción:
  ``rake lambdas:contact_form:upload_zip``

Los pasos 2, 3 y 4 son implementados por la tarea **:build_lambda**, lo que nos permite reducir los pasos necesarios a 3:

1. Escribir la mejora
2. Lanzar el _build_:
  ``rake lambdas:contact_form:build_lambda``
 (...hasta que pasen los tests)
3. Actualizar la _lambda_ de producción:
  ``rake lambdas:contact_form:upload_zip``

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tck-lambdas'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tck-lambdas --no-document

**NOTE**: use the **--no-document** option to avoid indexing lambdas's sources.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/the-cocktail/tck-lambdas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
