readme+howto=RAKE: Introducing tck-lambdas
==========================================

Introducción
------------

¿No sería fantástico que parte del build de nuestra aplicación fuese además una parte importante de su _README_ y de sus _HOWTOs_?

A la vuelta de mis vacaciones voy a incorporarme a un proyecto en _The Cocktail_ al que pude echar un ojo antes de empezarlas. Lo primero que hice fue bajarme su repo y leer su _README_. No tardé mucho: estaba vacío :(

Ya me habían avisado de que la documentación estaba en _Drive_. Recordaba que el enlace me lo habían mandado por _Slack_ y decidí meterlo en el _README_: cuantas menos cosas tuviese que recordar mejor, y el _README_ es mi lugar favorito para comenzar a aprender cosas de cualquier proyecto con el que comienzo a trabajar.

En realidad creo que se trata de un punto de entrada muy apropiado a cualquiera de nuestros proyectos de desarrollo: **todo gira en torno al repositorio** y se trataría de encargarse de que su _README_ fuese la **tarjeta de presentación del proyecto** para quienes se incorporan al mismo.

IMHO el único lugar que podría quitarle ese honor sería la portada de la _wiki_ del proyecto en _RedMine_. Todos los proyectos en _The Cocktail_ la tienen a su disposición y sin duda es una buena herramienta. Pero la realidad es que no la utilizamos en muchos de ellos, y algo parecido nos pasa con _Drive_.

El _README_ es la convención del software que utilizamos por debajo, y aunque casi siempre es ignorado nos acompaña desde nuestros principios en todos ellos. Y no tendría porque tratarse de algo difícil de mantener: en el peor de los casos podría ser **un simple listado con los enlaces más importantes**. Sólo teniendo los enlaces del proyecto a _RedMine_, _Drive_ o _Github_ ya estaría justificada su existencia.

Pero si además contiene la **narrativa que debe ser ejecutada como parte de su build** entonces ya la cosa, como se suele decir, _"iría a misa"_.

La gema _tck-lambdas_ tiene, por un lado, los _tests_ de cada una de las _lambdas_ que contiene, y por otro, sus propios _tests_. Los primeros están escritos haciendo uso de _Minitest_ y las posibilidades que nos ofrece _Amazon_ para testar _lambdas_ con su _ASW CLI_. Los segundos, los _tests_ de la propia gema, están escritos con _Cucumber_ y pretenden ser, como decía al comenzar, parte de su _README_ y sus _HOWTOs_.

Como no podía ser de otra forma el proyecto ya tiene [su _README_](http://github.com/the-cocktail/tck-lambdas). Desde que leí [el post de _Tom Preston-Werner_ definiendo Readme Driven Development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html) me quedé infectado por la motivación detrás del mismo y me gusta aplicarlo siempre que puedo. 

En este camino hacia la _Integración Continua_ usando _RDD_ voy a presentar la gema de una forma poco convencional: insertando código de su build. Espero que no os resulte _"infumable"_. :)

README (¿Qué es tck-lambdas?)
------

    **Feature: Developer lists AWS Lambda functions available in tck-lambdas.**
    As a Ruby developer with a library of AWS Lambda's functions
    I want to know which lambdas the tck-lambdas gem has
    So that i can use or create the one that my project needs
    
    Scenario: List available lambdas
      Given i have the AWS CLI installed in my system
        And i have the right crendentials in .aws/credentials
        And i'm on an empty project directory
        And i add the tck-lambdas gem to its current gems
       When i run "tck-lambdas list"
       Then the command succeeds
        And the output contains "contact_form"

    **Feature: Developer uses a new AWS Lambda function in her project.**
    As a Ruby developer with a set of generic AWS Lambda's functions
    I want to include a tck-lambdas' function in my current project
    So that i use the tck-lambdas' Rake tasks with it
    
    Background:
      Given i have the AWS CLI installed in my system
        And i have the right AWS crendentials
        And i'm on an empty Ruby project directory
        And i add the **tck-lambdas** gem to its current gems
    
    Scenario: Trying to add a lambda that does not exist
       When i run "tck-lambdas use *i_do_not_exist*"
       Then the command fails
        And the output contains "not found"
    
    Scenario: Adding an existent tck-lambda
       When i run "tck-lambdas use contact_form"
       Then the command succeeds
        And "tck_project_contact_form" is between project's lambdas

Bueno, el principio no es malo:

* **la narrativa _As-a.../I-want.../So that..._** [0] con la que debe comenzar cualquier _feature_ me permite contar el propósito principal de la gema,

* **el background** me permite contar sin entrar en detalles los requisitos que tiene cualquiera de los escenarios,

* **y los escenarios** describen dos posibles usos básicos de la herramienta y sus consecuencias.

Sigamos un poco con el _README_ antes de entrar en el _HOWTO_:

    **Feature: Developer creates the AWS Lambda for her project.**
    As a Ruby developer using a tck-lambda function in a project
    I want to create that lambda in AWS Lambda for that project
    So that i can start using it and run its build before deploying
    
    Background:
      Given i have the tck-lambdas in my current project
        And i run "tck-lambdas use contact_form"
    
    Scenario: Creating the lambda for the project
       When i set the lambda function name to **shine_contact_form**
        And i run "rake tck_lambdas:contact_form:create_function"
       Then "shine_contact_form" is an AWS Lambda function
        And the **contact_form**'s tests are green

Aquí pueden surgir dudas sobre lo significan algunos conceptos que se podrían aclarar añadiendo comentarios a la _feature_. Por ejemplo: _"¿A qué viene ahora "crear la AWS Lambda"? ¿No se supone que ya están creadas y las reutilizamos desde nuestro proyecto?"_

Aquí entra en juego la visión de _The Cocktail_ de esta problemática, que entiende cada Lambda en el contexto de un proyecto concreto. Pero como digo, con un comentario dentro de la _feature_ podría aclararse y que nuestro _README_ fuese más _"humano"_. Por ejemplo, bajo el título de la _feature_ podríamos poner:

    Feature: Developer creates the AWS Lambda for her project
    # ...after defining our lambda specific properties in the _.lambda.yml_ file.

En cualquier caso, estos conceptos de más alto nivel pueden aclararse en el _"texto libre"_ del _README_ y entenderse mejor según vamos aprendiendo más de las tecnologías implicadas (en este caso _AWS Lambda_).

Tenemos ya unos cuantos pasos cuya definición comienza a resultar algo _"intrigante"_ si no ambígua: ¿qué quiere decir exactamente _"i have the right AWS crendentials"_, o _"i set the lambda function name to..."_?, por ejemplo.

HOWTO (¿Y cómo hace lo dice que hace?)
-----

Aquí es donde entran las _step definitions_: la definición de los pasos de _Cucumber_ nos permiten especificar de una forma precisa lo que quiere decir cada uno de ellos:

    Given(/^i have the AWS CLI installed in my system$/) do
      unless `aws --version` =~ /#{Regexp.escape('aws-cli/1.10')}/ 
        raise "Sorry, AWS CLI v1.10.x should be working in your system."
      end
    end

En la definición de este paso podemos ver que tener _AWS CLI_ instalado en nuestro sistema significa que la orden ``aws --version`` devuelva como resultado de su ejecución, entre otras cosas, _"aws-cli/1.10"_.

No está mal. Podría estar mejor -p.e. facilitanto algún enlace concreto para conseguirlo, o puestos a pedir, detectando el sistema operativo y comenzando la instalación de la dependencia- pero no está mal. Vamos a seguir con el suguiente paso de nuestra _feature_, pero esta vez viendo lo que pasa si falla cuando ejecutamos ``rake`` desde la línea de comandos:

    **~/src/tck-lambdas $** rake
    Feature: Developer uses a new AWS Lambda function in her project.
    As a Ruby developer with a set of generic AWS Lambda's functions
    I want to include a tck-lambdas' function in my current project
    So that i use the tck-lambdas' Rake tasks with it
    
    Background:                                               # features/tck-lambdas-cli/use.feature:7
        Given i have the AWS CLI installed in my system       # features/step_definitions/system_steps.rb:1
        And i have the right crendentials in .aws/credentials # features/step_definitions/system_steps.rb:10                                                                                                      
          Sorry, AWS CLI should have credentials to access AWS Lambda. (RuntimeError)
          ./features/step_definitions/system_steps.rb:15:in `/^i have the right crendentials in \.aws\/credentials$/'                                                                                             
          features/tck-lambdas-cli/use.feature:9:in `And i have the right crendentials in .aws/credential
    **~/src/tck-lambdas $**

El error que nos devuelve ya nos está dando bastantes pistas sobre el problema que tiene, pero por supuesto podemos mirar la definición del paso para ver más en detalle lo que falla:

    Given(/^i have the right AWS crendentials$/) do
      cmd = "aws lambda list-functions --max-items 0"
      expected = '"Functions": []'
    
      unless `#{cmd}` =~ /#{Regexp.escape(expected)}/
        raise "Sorry, AWS CLI should have credentials to access AWS Lambda."
      end
    end

En la definición podemos ver la orden que está lanzando para comprobar si tenemos los permisos adecuados: ``aws lambda list-functions --max-items 0``. Sin entrar juicios sobre la implementación de esta comprobación, **queda claro lo que _tck-lambdas_ espera de nuestro sistema para funcionar correctamente**.

Cuando nos instalamos algo esperamos que funcione correctamente, o que al menos su documentación nos de pistas sobre lo que le puede estar faltando para hacerlo. De esto último se han encargado tradicionalmete los _HOWTO_s, y en el caso de nuestra gema consistiría en comenzar a iterar de igual forma que cuando estamos desarrollando con TDD: lanzamos _"rake"_ resolviendo cada problema hasta que pasen todos los tests.

A diferencia de los primeros pasos qué sólo comprobaban que el sistema cumple determinados requisitos, varios de los pasos posterires pasan a la acción y preparan el entorno de ejecución del test. Por ejemplo, si entramos a ver la definiición de _"i'm on an empty Ruby project directory"_ veríamos que crea un _Gemfile_ apuntando a _RubyGems.org_ en un directorio vacío.

Pero vamos dejar ya nuestro _HOWTO_ para continuar con la presentación de la gema.

rake (pero... ¿cuáles son esas tareas Rake?)
----

_tck-lambdas_ añade nuevas tareas a nuestro proyecto cuando le indicamos que queremos hacer uso de alguna de sus lambdas.

Si por ejemplo le indicamos que queremos hacer uso de su *lambda contact_form* tendremos a nuestra disposición las siguientes tareas:

* lambdas:contact_form:create_lambda
* lambdas:contact_form:create_zip
* lambdas:contact_form:upload_zip
* lambdas:contact_form:upload_test
* lambdas:contact_form:test
* lambdas:contact_form:build
* lambdas:test

Añadiendo aliases en nuestro _Rakefile_ podemos acortar los nombres de estas tareas (p.e. ``task zip: "lambdas:contact_form:create_zip"``).

### rake create_lambda

Cuando le decimos a _tck-lambdas_ que queremos hacer uso de una de sus _lambdas_ -``tck-lambdas use [...]``- la gema intentará crear un fichero ``.lambda.yml`` en la raiz de nuestro proyecto con las propiedades que tendrá la función _lambda_ de nuestro proyecto.

Por ejemplo, para la función *contact_form* nos creará el siguiente ``.lambdas.yml``:

    # The Cockatil's AWS Lambda functions configuration
    contact_form:
      function-name: project_name_contact_form
      handler: project_name_contact_form.handler
      timeout: 30
      memory-size: 128
      runtime: nodejs4.3
      role: lambda_contact_form_role
      description: Project Name instance of the Tck's contact_form lambda

De su contenido tenemos que cambiar _"project name"_ por el nombre de nuestro proyecto y _role_ por un rol _ARN_ (_Amazon Resource Name_) con los permisos que necesita nuestra _lambda_. Un listado con los roles disponibles y sus _ARN_ puede obtenerse con el comando ``aws iam``:

    aws iam list-roles --query "Roles[].[RoleName,Arn]"

Con el rol apropiado ``rake lambdas:contact_form:create_lambda`` debería crearnos la nueva función en AWS Lambda, y otra con el mismo nombre terminado en *_test* para la ejecución de sus tests. Podemos comprobarlo lanzando ``aws lambda list-functions``.

### create_zip
    # Generate lambda's ZIP file with source/* code (use :build best)

### upload_zip
    # Update contact_form lambda w/ /tmp/tck-lambdas/contact_form.zip (use :build_lambda first)

### upload_test
    # Update the contact_form_test lambda code (creating & uploading the ZIP file)

### test
    # Run lambda tests

### build
    # Update tests lambda and test it (create_zip+upload_tests+test).

### lambdas:test
    # Run all lambdas' tests
