-- 8. Realiza los módulos de programación necesarios para evitar que una versión de un experimento tenga colaborando más de cinco investigadores si usa menos de tres ingredientes elaborados a partir de otros.

Primero se ha realizado la función que comprueba si una versión del experimento tiene menos de 3 ingredientes teniendo en cuenta los ingredientes que se han elaborado a partir de otros, usando de parametros de entrada el codigo de la version y el codigo del experimento haciendo uso de un cursor para recorrer los ingredientes de la version y un cursor anidado para recorrer los ingredientes que se han elaborado a partir de otros. La función devuelve el numero de ingredientes que tiene la version:

```sql
create or replace function contar_ingredientes_xversion (p_codigo ingredientesporversion.CodigoVersion%type, p_codigoexperimento ingredientesporversion.codigoexperimento%type)
return number
is
  v_num_ingredientes number:=0;
  cursor c_ingrediente is select * from ingredientesporversion where codigoversion = p_codigo and codigoexperimento = p_codigoexperimento;
  v_cantidad number;

begin

    for ingrediente in c_ingrediente loop

    select count(CodigoIngredienteFinal) into v_cantidad from compingredientespre 
    where CodigoIngredienteFinal = ingrediente.CodigoIngrediente;
    
        if v_cantidad > 0 then
            v_num_ingredientes := v_num_ingredientes + 1;
        end if;

    end loop;

    return v_num_ingredientes;

end;
/
```

Para probar la función se ha usado el siguiente procedimiento que, metiendo el codigo de la version y el codigo del experimento, devuelve el numero de ingredientes que tiene la version:

```sql
create or replace procedure probarfuncion (p_codigoversion in ingredientesporversion.codigoversion%type, p_codigoexperimento in ingredientesporversion.codigoexperimento%type)
is
  v_num_ingredientes number;
begin
    v_num_ingredientes := comprobar_ingredientes (p_codigoversion, p_codigoexperimento);
    dbms_output.put_line (v_num_ingredientes);
end;
/
```

Para ejecutar el procedimiento se ha usado la siguiente sentencia donde se le pasa el codigo de la version y el codigo del experimento:

```sql
exec probarfuncion ('0.0.3','A0001-A');
```

![img](/tasks/img/ejercicio8/1.png)


Ahora vamos a realizar el procedimiento que comprueba si se pueden añadir más investigadores a la versión del experimento teniendo como parámetros de entrada el codigo de la version y el codigo del experimento. El procedimiento comprueba si la versión del experimento tiene más de 5 investigadores y si tiene menos de 3 ingredientes, en ese caso lanza un error mediante la función anterior. Si no se cumple ninguna de las dos condiciones, no se lanza ningún error y se muestra por pantalla el número de investigadores que tiene la versión del experimento: 

```sql
create or replace procedure comprobar_investigadores (p_codigoexperimento in colaboraciones.codigoexperimento%type, p_codigoversion in colaboraciones.codigoversion%type)
is

  v_num_investigadores number;


begin
    
    select count(*) into v_num_investigadores from colaboraciones where codigoexperimento = p_codigoexperimento and codigoversion = p_codigoversion;
    
    dbms_output.put_line (v_num_investigadores);
    
    if v_num_investigadores > 4 and comprobar_ingredientes (p_codigoversion, p_codigoexperimento) < 3 then
        
        raise_application_error(-20001, 'No se pueden añadir más investigadores a esta versión del experimento ');
    
    end if;
end;
/
```

Y para probarlo se ha usado la siguiente sentencia en caso de que: 

* Si probamos con un experimento que tiene menos de 5 investigadores y con menos de 3 ingredientes, no se lanza ningún error, solo se muestra por pantalla el número de investigadores que tiene la versión del experimento:

```sql
exec comprobar_investigadores ('A0001-A','0.0.2');
```

![img](/tasks/img/ejercicio8/2.png)

* Si probamos con un experimento que tiene más de 5 investigadores y con menos de 3 ingredientes, se lanza el error:

```sql
exec comprobar_investigadores ('A0001-A','0.0.1');
```

![img](/tasks/img/ejercicio8/4.png)


Lo último será crear el trigger que llame al procedimiento anterior cada vez que se inserte o actualice una colaboración en la tabla colaboraciones usando el procedimiento anterior dentro del trigger, de tal mmanera que se compruebe si se pueden añadir más investigadores a la versión del experimento antes de insertar o actualizar la colaboración:

```sql
create or replace trigger ejercicio8
before insert or update on colaboraciones
for each row
begin

    comprobar_investigadores (:new.codigoexperimento, :new.codigoversion);

end;
/
```

Para probarlo, necesitamos insertar un investigador nuevo en la tabla investigadores:

```sql
insert into investigadores values('46321475H','Artemia','Salada','C/ Agua 1, Sevilla','695842156','Carnes');
```

Insertamos 5 colaboraciones para que el experimento tenga 6 investigadores y salte el error:

```sql
insert into colaboraciones values('A0001-A','0.0.1','41254785F');
insert into colaboraciones values('A0001-A','0.0.1','48521484V');
insert into colaboraciones values('A0001-A','0.0.1','52146359T');

insert into colaboraciones values('A0001-A','0.0.1','54215869Q');
insert into colaboraciones values('A0001-A','0.0.1','46321475G');

insert into colaboraciones values('A0001-A', '0.0.1', '46321475H');
```

![img](/tasks/img/ejercicio8/3.png)


*Nota: Para eliminar las colaboraciones que hemos insertado, usamos la siguiente sentencia:

```sql
delete from colaboraciones where codigoexperimento = 'A0001-A' and codigoversion = '0.0.1';
```
