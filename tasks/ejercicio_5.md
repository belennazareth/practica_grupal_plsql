
-- 5. Añade una columna llamada PuntuaciónMedia a la tabla Versiones. Rellénala mediante un procedimiento PL/SQL a partir de las notas existentes en la tabla Puntuaciones y realiza los módulos de programación necesarios para mantener la columna debidamente actualizada cuando la tabla Puntuaciones sufra algún cambio con el mínimo consumo de recursos posible (esto es, realizando el menor número posible de cálculos).

Añadimos la nueva columna a la tabla versiones donde vamos a insertar las medias de los valores de la tabla puntuaciones 
``` sql
ALTER TABLE versiones ADD PuntuacionMedia number(10);
```

Creamos un procedimiento que saque todos los experimentos
``` sql
CREATE OR REPLACE PROCEDURE obtenercodigoexperimento
IS
    cursor c_experimentos is SELECT codigoexperimento FROM versiones GROUP BY codigoexperimento;
BEGIN
    for var in c_experimentos LOOP
        obtenernotas(var.codigoexperimento);
    end loop;
END;
/
```

Creamos un procedimiento que saque todas las versiones de cada experimento
``` sql
CREATE OR REPLACE PROCEDURE obtenernotas (p_codigoexperimento puntuaciones.codigoexperimento%TYPE)
IS
    cursor c_versiones is SELECT codigoversion FROM puntuaciones WHERE codigoexperimento = p_codigoexperimento GROUP BY codigoversion;
BEGIN
    for var in c_versiones LOOP
        calculodenotas(var.codigoversion,p_codigoexperimento);
    end loop;
END;
/
```

Creamos un procedimiento para calcular las medias a partir de una versión y un experimento
``` sql
CREATE OR REPLACE PROCEDURE calculodenotas (p_version puntuaciones.codigoversion%TYPE, p_codigoexperimento puntuaciones.codigoexperimento%TYPE)
IS
    c_acumulador number:=0;
    c_suma number:=0;
    c_calculototal number:=0;
BEGIN
    SELECT sum(valor),count(*) INTO c_acumulador,c_suma FROM puntuaciones WHERE codigoversion = p_version AND codigoexperimento = p_codigoexperimento;
    c_calculototal := c_acumulador/c_suma;
    UPDATE versiones set puntuacionmedia = c_calculototal WHERE codigo = p_version AND codigoexperimento = p_codigoexperimento;
END;
/
```

Creamos un trigger para que cada vez que se hagan cambios en la tabla puntuaciones, se actualizarán todos los valores de la puntuacion media de la tabla versiones ejecutando los procedimientos creados anteriormente
``` sql
CREATE OR REPLACE TRIGGER nocambios
AFTER UPDATE OR INSERT OR DELETE ON puntuaciones
DECLARE
BEGIN
    obtenercodigoexperimento;
END;
/
```

Comprobación:
Primero ejecutamos el procedimiento que añade la puntuacion media de los experimentos a la nueva columna de la tabla versiones y luego probamos actualizando todos los datos de la tabla puntuaciones de un experimento concreto para que su media sea 7, y al listar las puntuaciones medias de la tabla versiones vemos que se ha actualizado automáticamente
![Comprobación ejercicio 5](img/ejercicio5.png)
