-- 4. Realiza un trigger que cada vez que se inserte una puntuación menor de 5, informe de este hecho 
-- por correo electrónico al investigador responsable del experimento, incluyendo en el correo la 
-- fecha de la prueba, el aspecto valorado y donde vive el catador.

create trigger puntuacion_menor_5
after insert on Puntuaciones
for each row
if new.valor < 5
begin
    declare email varchar(50);
    select email into email from investigador where id_investigador = new.id_investigador;
    call enviar_correo(email, 'Puntuación menor de 5', concat('La puntuación de la prueba ', new.id_prueba, ' es menor de 5'));
end
