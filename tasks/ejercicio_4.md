-- 4. Realiza un trigger que cada vez que se inserte una puntuación menor de 5, informe de este hecho por correo electrónico al investigador responsable del experimento, incluyendo en el correo la fecha de la prueba, el aspecto valorado y donde vive el catador.


Lo primero será alterar la tabla de investigadores para que tenga un correo electrónico, para ello:

```sql
alter table investigadores 
add email varchar2(50);
```

Después, meteremos valores para los investigadores:

```sql
update investigadores set email='pedro@gmail.com' where NIF='41254785F';
update investigadores set email='rosa@gmail.com' where NIF='48521484V';
update investigadores set email='belennazareth29@gmail.com' where NIF='52146359T';
```





```sql

create or replace function conseguirEmailInvestigador(p_CodigoExperimento experimentos.Codigo%type)
return varchar2
is
    v_email varchar2(50);
begin
    select email into v_email 
    from investigadores 
    where NIF = (select NIFInvestigador
                    from experimentos
                    where Codigo = p_CodigoExperimento);
    return v_email;
end;
/



create trigger puntuacion_menor_5
after insert or update on Puntuaciones
for each row

declare
    v_email varchar2(50);
begin

    if new.valor < 5 then
        v_email := conseguirEmailInvestigador(new.CodigoExperimento);

        call enviar_correo(email, 'Puntuación menor de 5', concat('La puntuación de la prueba ', new.id_prueba, ' es menor de 5'));
    
    end if;

end
```