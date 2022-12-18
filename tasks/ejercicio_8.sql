-- 8. Realiza los módulos de programación necesarios para evitar que una versión de un experimento 
-- tenga colaborando más de cinco investigadores si usa menos de tres ingredientes elaborados a partir 
-- de otros.

create or replace function comprobar_ingredientes (p_codigo ingredientesporversion.CodigoIngrediente%type, p_codigoexperimento ingredientesporversion.codigoexperimento%type)
return number
is
  v_num_ingredientes number:=0;
  cursor c_ingrediente is select * from ingredientesporversion where codigoversion = p_codigo and codigoexperimento = p_codigoexperimento;
  v_cantidad number;

begin

    select count(*) into v_num_ingredientes from ingredientesporversion where codigoversion = p_codigo and codigoexperimento = p_codigoexperimento;


    for ingrediente in c_ingrediente loop
    select CodigoIngredienteFinal into v_cantidad from compingredientespre 
    where CodigoIngredienteFinal = ingrediente.CodigoIngrediente;
    
        if v_cantidad > 0 then
            v_num_ingredientes := v_num_ingredientes + 1;
        end if;
    end loop;

    return v_num_ingredientes;

end;
/


create or replace procedure comprobar_investigadores (p_codigoexperimento in puntuaciones.codigoexperimento%type, p_codigoversion in puntuaciones.codigoversion%type)
is
  v_num_investigadores number;

begin

    select codigoexperimento, codigoversion into p_codigoexperimento, p_codigoversion from puntuaciones;
    
    select count(*) into v_num_investigadores from puntuaciones where codigoexperimento = p_codigoexperimento and codigoversion = p_codigoversion;
    
    if v_num_investigadores > 5 then
        
        if comprobar_ingredientes (p_codigoversion, p_codigoexperimento) < 3 then
            raise_application_error(-20001, 'No se pueden añadir más investigadores a esta versión del experimento');
        
        end if;
end;
/