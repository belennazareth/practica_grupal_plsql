-- 3. Realiza un trigger que impida que se pruebe una versión de un experimento antes de
-- que éste comience o después de que termine.
```sql
create or replace trigger ejercicio3 before insert or update on Versiones for each row
declare
l_fechainicio experimentos.fechainicio%type;
l_fechafin experimentos.fechafin%type;
begin
select fechainicio into l_fechainicio from Experimentos where codigo = :new.codigoexperimento;
select fechafin into l_fechafin from Experimentos where codigo = :new.codigoexperimento;
    if :new.fechaprueba < l_fechainicio then
        raise_application_error(-20002, 'La fecha de prueba no puede ser menor a la fecha de inicio de experimentos');
    end if;
    if :new.fechaprueba > l_fechafin then
        raise_application_error(-20003, 'La fecha de prueba no puede ser mayor a la fecha de fin de experimentos');
    end if;
end ejercicio3;
/

```
