-- 4. Realiza un trigger que cada vez que se inserte una puntuación menor de 5, informe de este hecho por correo electrónico al investigador responsable del experimento, incluyendo en el correo la fecha de la prueba, el aspecto valorado y donde vive el catador.

---

Para poder enviar correos electrónicos desde Oracle, se ha tenido que realizar una configuración previa, para ello, se ha tenido que ejecutar los siguientes comandos en la consola de Oracle como usuario sys:

```sql
@$ORACLE_HOME/rdbms/admin/utlmail.sql

@$ORACLE_HOME/rdbms/admin/prvtmail.plb

ALTER SYSTEM SET smtp_out_server='localhost' SCOPE=BOTH;

BEGIN
  DBMS_NETWORK_ACL_ADMIN.CREATE_ACL(
    acl => 'aclemail.xml',
    description => 'enviar correos',
    principal => 'NAZARETH',
    is_grant => true,
    privilege => 'connect',
    start_date => SYSTIMESTAMP,
    end_date => NULL
  );
  COMMIT;
END;
/

BEGIN
  DBMS_NETWORK_ACL_ADMIN.ASSIGN_ACL (
    acl => 'aclemail.xml',
    host => '*',
    lower_port => NULL,
    upper_port => NULL
  );
  COMMIT;
END;
/

grant execute on UTL_MAIL to NAZARETH;

```

Para enviar un correo de prueba se ha tenido que ejecutar el siguiente código donde se ha tenido que introducir el correo electrónico del remitente y del destinatario además del asunto y el mensaje para poder enviarlo:

```sql
BEGIN
  UTL_MAIL.SEND (
    sender => 'belennazareth29@gmail.com',
    recipients => 'belennazareth29@gmail.com',
    subject => 'Pruebesita',
    message => 'Correito de prueba'
  );
END;
/
```

---


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

Se ha creado una función que recibe el código del experimento y devuelve el correo electrónico del investigador que lo ha creado para obtenerlo en el trigger:

```sql
create or replace function conseguirEmailInvestigador(p_CodigoExperimento experimentos.Codigo%type)
return varchar2
is
    v_email investigadores.email%type;
begin
    select email into v_email 
    from investigadores 
    where NIF = (select NIFInvestigador
                    from experimentos
                    where Codigo = p_CodigoExperimento);
    return v_email;
end;
/
```

Se ha creado una función que recibe el código de la versión y devuelve la fecha de la prueba, con esto se podrá enviar un correo con la fecha de la prueba en la que se ha obtenido una puntuación menor de 5:

```sql
create or replace function obtenerFechaPrueba(p_codigoVersion Versiones.Codigo%type)
return date
is
    v_fecha versiones.FechaPrueba%type;
begin
    select FechaPrueba into v_fecha 
    from versiones 
    where codigo = p_codigoVersion;
    return v_fecha;
end;
/
```

La siguiente función recibe el código del aspecto y devuelve la descripción del mismo:

```sql
create or replace function obtenerAspecto(p_codigoAspecto Aspectos.Codigo%type)
return varchar2
is
    v_aspecto aspectos.Descripcion%type;
begin
    select Descripcion into v_aspecto 
    from aspectos 
    where codigo = p_codigoAspecto;
    return v_aspecto;
end;
/
```

La siguiente función recibe el NIF del catador y devuelve la dirección de su vivienda:

```sql
create or replace function obtenerViviendaCatador(p_nifCatador Catadores.NIF%type)
return varchar2
is
    v_vivienda_catador catadores.Direccion%type;
begin
    select Direccion into v_vivienda_catador 
    from catadores 
    where NIF = p_nifCatador;
    return v_vivienda_catador;
end;
/
```

Es necesario crear un procedimiento (enviar_correo) para que al introducirlo en el trigger se pueda enviar el correo electrónico. Este procedimiento recibe el correo electrónico del remitente, el correo electrónico del destinatario, el asunto, el mensaje y el host del servidor de correo. El host del servidor de correo se ha tenido que poner en el archivo tnsnames.ora para que se pueda conectar con el servidor de correo. 
El procedimiento se ha creado en el esquema NAZARETH para que se pueda ejecutar desde el trigger, usando utl smtp que es un paquete de Oracle que permite enviar correos electrónicos y elaborando un formato usando la función ltrim y rtrim para eliminar los espacios en blanco del host del servidor de correo. 
En mesg se ha creado el mensaje que se va a enviar en el correo electrónico, en este caso se ha usado el formato de correo electrónico que se usa en el protocolo **SMTP** (protocolo de transferencia de correo electrónico).
Se ha usado el método open_connection para abrir la conexión con el servidor de correo y el método send para enviar el correo electrónico:


```sql
create or replace procedure enviar_correo(p_envia IN VARCHAR2, p_recibe IN VARCHAR2, p_asunto IN VARCHAR2, p_mensaje IN VARCHAR2, p_host IN VARCHAR2) 
IS 
  mailhost     VARCHAR2(80) := ltrim(rtrim(p_host)); 
  mail_conn    utl_smtp.connection;  
   
  crlf VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 ); 
  mesg VARCHAR2( 1000 ); 
BEGIN 
  mail_conn := utl_smtp.open_connection(mailhost, 25); 
  mesg:= 'Date: ' || TO_CHAR( SYSDATE, 'dd Mon yy hh24:mi:ss' ) || crlf || 
         'From:  <'||p_envia||'>' || crlf || 
         'Subject: '||p_asunto|| crlf || 
         'To: '||p_recibe || crlf || 
         '' || crlf || p_mensaje; 
 
  utl_smtp.helo(mail_conn, mailhost); 
  utl_smtp.mail(mail_conn, p_envia);  
  utl_smtp.rcpt(mail_conn, p_recibe); 
  utl_smtp.data(mail_conn, mesg);   
  utl_smtp.quit(mail_conn);         
END; 
/
```

En el siguiente trigger se comprueba si la puntuación es menor de 5, si es así, se obtienen los datos necesarios para enviar el correo electrónico y se envían tanto el email como la fecha de la prueba, el aspecto valorado y la dirección de la vivienda del catador:

```sql
create trigger puntuacion_menor_5
after insert or update on Puntuaciones
for each row

declare
    v_email investigadores.email%type;
    v_fecha versiones.FechaPrueba%type;
    v_aspecto aspectos.Descripcion%type;
    v_vivienda_catador catadores.Direccion%type;
begin

    if new.valor < 5 then
        v_email := conseguirEmailInvestigador(new.CodigoExperimento);
        v_fecha := obtenerFechaPrueba(new.CodigoVersion);
        v_aspecto := obtenerAspecto(new.CodigoAspecto);
        v_vivienda_catador := obtenerViviendaCatador(new.NIFCatador);
        
        enviar_correo('nazareth@localhost', v_email, 'Puntuación menor de 5', 'La puntuación de la prueba '||v_fecha||' del aspecto '||v_aspecto||' del catador '||new.NIFCatador||' que vive en '||v_vivienda_catador||' es menor de 5', 'localhost');

    end if;

end
```

