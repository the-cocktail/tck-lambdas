# Tck::Lambdas

_Tck::Lambdas_ es una _gema_ que facilita la utilización de una _AWS Lambda_ en el contexto de un proyecto _Ruby_ introduciendo en el mismo tareas de _Rake_ que realizan las **órdenes AWS** que debemos ejecutar habitualmente desde la _línea de comandos_.

Por ejemplo, si tenemos una _función lambda_ llamada **shine** y queremos subir una mejora en su código tendríamos que, por un lado generar el _zip_ con dicha mejora, y por otro actualizar el mismo en _AWS Lambda_ (con la función ``aws lambda update-function-code`` o a través de su consola web).
    
Si hemos instalado la gema _Tck::Lambdas_ en nuestro proyecto y hemos indicado en que el mismo hace uso de la _lambda shine_ (bundle exec ``tck-lambdas use shine``), lanzaríamos la siguiente orden para crear el _zip_:

    $ rake lambdas:shine:create_zip

Y esta para subir el mismo a _AWS Lambda_ (para _"desplegar"_ la mejora):

    $ rake lambdas:shine:upload_zip

Si sólo tenemos esa _lambda_, creando el _alias_ necesario en nuestro _Rakefile_ (``task deploy_lambda: "lambdas:shine:upload_zip"``) podríamos lanzar simplemente:

    $ rake deploy_lambda

Usando una _lambda_
-------------------

Vamos a meter un _formulario de contacto_ en nuestro **proyecto Amazing** y queremos usar la *lambda contact_form*. Instalamos la _gema Tck::Lambdas_ y le indicamos que nuestro proyecto hace uso de la _lambda_ llamada *contact_form*:

    $ echo "gem 'tck-lambdas'" >> Gemfile      # Metemos la gema en nuestro Gemfile...
    $ bundle                                   #  - la instalamos y...
    $ bundle exec tck-lambdas use contact_form #  - y usamos la lambda:
    => lambdas/contact_form/ created with the lambda sources & tests.
    => task/lambdas/contact_form.rake created with common tasks.
    => .lambdas.yml created with the contact_form lambda conf.
    
Tal y como nos avisa ha creado, entre otras cosas, el fichero *.lambdas.yml* con la configuración para nuestra función _lambda_ con el siguiente contenido:

    contact_form:
      function-name: tck_project_contact_form
      handler: tck_project_contact_form.handler
      timeout: 30
      memory-size: 128
      runtime: nodejs4.3
      role: lambda_contact_form_role

Todos los valores por defecto deberían ser válidos excepto el nombre de la función (_function-name_), su manejador (_handler_), y su role.

En el nombre del la función y su manejador tenemos que sustituir *tck_project* por el nombre de nuestro proyecto (quedándonos con *amazing_contact_form* y *amazing_contact_form.handler* respectivamente).

El role tenemos que sustituirlo por el que corresponda de los que nos devuelve AWS:

    aws iam list-roles --query "Roles[].[RoleName,Arn]"

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

    $ gem install tck-lambdas

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/tck-lambdas. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
