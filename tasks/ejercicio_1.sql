-- 1. Realiza una función que reciba un código de experimento, un código de versión y el nombre de un
-- ingrediente y muestre la cantidad total del ingrediente necesario para una versión. Debes tener en
-- cuenta que el ingrediente puede usarse como base de otros ingredientes preparados y/o directamente
-- en la versión del experimento. Debes contemplar las siguientes excepciones: Experimento inexistente,
-- Versión inexistente para ese experimento e Ingrediente no empleado en dicha versión.

-- 1. Realiza una función que reciba un código de experimento, un código de versión y el nombre de un ingrediente y muestre la cantidad total del ingrediente necesario para una versiónXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX. Debes tener en cuenta que el ingrediente puede usarse como base de otros ingredientes preparados y/o directamente en la versión del experimento. Debes contemplar las siguientes excepciones: Experimento inexistente, Versión inexistente para ese experimento e Ingrediente no empleado en dicha versión.

-- ejemplo con select:
select cantidad from ingredientesporversion where codigoVersion='0.0.2' and codigoExperimento='A0004-A' and codigoIngrediente=(select codigo from ingredientes where nombre='Guisante');

CREATE OR REPLACE FUNCTION cantidad_ingrediente(p_exp Experimentos.Codigo%type, p_ver Versiones.Codigo%type, p_ing Ingredientes.Nombre%type)
return number
is
    v_cantidad number;
    v_total number:=0;
    v_numero_prep number:=0;
    v_cod_ing Ingredientes.Codigo%type;
begin
    select codigo into v_cod_ing from ingredientes where nombre=p_ing;
    select count(*) into v_numero_prep from CompIngredientesPre where CodigoIngredienteBase = v_cod_ing;
    -- comprobamos que el ingrediente es base
    if v_numero_prep > 0 then
        -- si es base de un ingrediente preparado, llamamos a la funcion cantidad_base_prep para que nos devuelva la cantidad de ese ingrediente base que necesitamos para hacer 1 unidad de cada ingrediente preparado que lo contenga
        v_total := v_total+cantidad_base_prep(p_exp, p_ver, v_cod_ing);
    else
        -- si no es base de ningun ingrediente preparado, buscamos la cantidad de ese ingrediente en la version
        select cantidad into v_cantidad from ingredientesporversion where codigoVersion=p_ver and codigoExperimento=p_exp and codigoIngrediente= v_cod_ing;
    end if;

    return v_cantidad;

end;
/

-- Funcion que devuelva la cantidad de ingredientes base necesarios para hacer 1 unidad de un ingrediente preparado
CREATE OR REPLACE FUNCTION cantidad_base_prep(p_exp Experimentos.Codigo%type, p_ver Versiones.Codigo%type, p_cod_ing Ingredientes.Codigo%type)
return number
is
    cursor c_preparados is
        SELECT CodigoIngredienteFinal,cantidad
        from CompIngredientesPre
        where CodigoIngredienteBase=p_cod_ing;
    v_total number:=0;
    v_producto number;
begin
    for v_preparado in c_preparados loop
        select cantidad into v_producto from ingredientesporversion where codigoVersion=p_ver and codigoExperimento=p_exp and codigoIngrediente= v_preparado.CodigoIngredienteFinal;
        v_total:= v_total + (v_producto * v_preparado.cantidad);
    end loop;
    return v_total;
end;
/


-- PRUEBAS DE FUNCIONAMIENTO
-- el 15 (platano esta 2 veces en el a0002-a, 0.0.2)
create or replace procedure prueba_1
is
    v_cantidad number;
begin
    v_cantidad := cantidad_base_prep('A0002-A','0.0.2','0004');
    dbms_output.put_line('Cantidad de aceite necesarios: '||v_cantidad);
end;
/
insert into ingredientesporversion values('0047','A0002-A','0.0.2',50);
insert into compingredientespre values('0004','0047','15');
insert into Ingredientes values('0004','Huevo','Ovum');

