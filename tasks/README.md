# PROYECTO Restaurantes

## Fase 4: Explotación de la Base de Datos mediante PL/SQL

1. **Realiza una función que reciba un código de experimento, un código de versión y el nombre de un ingrediente y muestre la cantidad total del ingrediente necesario para una versión. Debes tener en cuenta que el ingrediente puede usarse como base de otros ingredientes preparados y/o directamente en la versión del experimento. Debes contemplar las siguientes excepciones: Experimento inexistente, Versión inexistente para ese experimento e Ingrediente no empleado en dicha versión.**

    [Resolución](/tasks/ejercicio_1.sql)


2. **Deseamos realizar, con el menor número posible de consultas a la base de datos, un procedimiento llamado MostrarInformes que reciba cuatro parámetros. El primero será el tipo de informe, el segundo un código de experimento y los dos últimos dependerán del tipo de informe.**

    **Informe Tipo 1: Los dos últimos parámetros estarán en blanco. Este informe mostrará todas las puntuaciones que ha recibido un experimento, mostrando sus versiones ordenadas cronológicamente, los aspectos de mayor a menor importancia y las puntuaciones de mayor a menor. El formato del informe será el siguiente:**

    ```sql
    Código Experimento: xxxxxxxxxxx Investigador Responsable: xxxxxxxxxxxxxx
    Versión1: xxxxxxxxxxxxxx
    Fecha Prueba: xx/xx/xxxx
    Código Aspecto1: xxxxxxxxxxx1
    NombreCatador1
    Importancia: xxxxxxxxxxxx
    Puntuación
    ...
    NombreCatadorN
    Puntuación
    Nota Media Aspecto xxxxxxxxxx1: n.nn
    …
    Código AspectoN: xxxxxxxxxxxN
    NombreCatador1
    Importancia: xxxxxxxxxxxx
    Puntuación
    ...
    NombreCatadorN
    Puntuación
    Nota Media Aspecto xxxxxxxxxxN: n.nn
    Puntuación Media Versión1: n.nn
    ...
    Versión2:
    …
    ```

    **Informe Tipo 2: El tercer parámetro será un código de versión. Este informe mostrará todas las puntuaciones que ha recibido una versión de un experimento, mostrando los aspectos de mayor a menor importancia y las puntuaciones de mayor a menor. El formato del informe será el siguiente:**

    ```sql
    Código Experimento: xxxxxxxxxxx Investigador Responsable: xxxxxxxxxxxxxx
    Versión: xxxxxxxxxxxxxx
    Fecha Prueba: xx/xx/xxxx
    Código Aspecto1: xxxxxxxxxxx1
    Importancia: xxxxxxxxxxxxNombreCatador1
    Puntuación
    ...
    NombreCatadorN
    Puntuación
    Nota Media Aspecto xxxxxxxxxx1: n.nn
    …
    Código AspectoN: xxxxxxxxxxxN
    NombreCatador1
    Importancia: xxxxxxxxxxxx
    Puntuación
    ...
    NombreCatadorN
    Puntuación
    Nota Media Aspecto xxxxxxxxxxN: n.nn
    Puntuación Media Versión: n.nn
    ```

    **Informe Tipo 3: El tercer parámetro será un código de versión. El cuarto será un código de aspecto Este informe mostrará todas las puntuaciones que ha recibido un aspecto de una versión de un experimento, mostrando las puntuaciones de mayor a menor. El formato del informe será el siguiente:**

    ```sql
    Código Experimento: xxxxxxxxxxx Investigador Responsable: xxxxxxxxxxxxxx
    Versión: xxxxxxxxxxxxxx
    Fecha Prueba: xx/xx/xxxx
    Código Aspecto1: xxxxxxxxxxx1
    NombreCatador1
    Importancia: xxxxxxxxxxxx
    Puntuación
    ...
    NombreCatadorN
    Puntuación
    Nota Media Aspecto xxxxxxxxxx1: n.nn
    ```

    [Resolución](/tasks/ejercicio_2.sql)


3. **Realiza un trigger que impida que se pruebe una versión de un experimento antes de que éste comience o después de que termine.**

    [Resolución](/tasks/ejercicio_3.sql)


4. **Realiza un trigger que cada vez que se inserte una puntuación menor de 5, informe de este hecho por correo electrónico al investigador responsable del experimento, incluyendo en el correo la fecha de la prueba, el aspecto valorado y donde vive el catador.**

    [Resolución](/tasks/ejercicio_4.sql)


5. **Añade una columna llamada PuntuaciónMedia a la tabla Versiones. Rellénala mediante un procedimiento PL/SQL a partir de las notas existentes en la tabla Puntuaciones y realiza los módulos de programación necesarios para mantener la columna debidamente actualizada cuando la tabla Puntuaciones sufra algún cambio con el mínimo consumo de recursos posible (esto es, realizando el menor número posible de cálculos).**

    [Resolución](/tasks/ejercicio_5.sql)


6. **Realiza los módulos de programación necesarios para evitar que un catador puntue más de tres aspectos de una misma versión de un experimento.**

    [Resolución](/tasks/ejercicio_6.sql)


7. **Realiza los módulos de programación necesarios para evitar que un investigador figure como colaborador de un experimento del que es responsable.**

    [Resolución](/tasks/ejercicio_7.sql)


8. **Realiza los módulos de programación necesarios para evitar que una versión de un experimento tenga colaborando más de cinco investigadores si usa menos de tres ingredientes elaborados a partir de otros.**

    [Resolución](/tasks/ejercicio_8.sql)

