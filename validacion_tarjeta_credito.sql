CREATE DEFINER=`encuesta`@`localhost` PROCEDURE `validacion_tarjeta_credito`(in pv_numero_tarjeta varchar(100),out pv_resultado varchar(500),out pn_resultado int)
BEGIN
-- Proposito: Programa de validacion de tarjetas de credito
-- Creado por: Diana Molina
-- Fecha: 14/01/2018


-- Declaracion de Variables      
declare lv_numero_tarjeta varchar(100);
declare ln_validacion int;
declare ln_longitud_tarjeta int;
declare ln_contador int default 0;
declare ln_suma_valores int default 0;
declare lv_cadena varchar(500) DEFAULT '';
declare lv_caracter varchar(500) DEFAULT '';
declare ln_suma int default 0;

-- Mensajes del Sistema
-- Si ln_resultado es 0 esta incorrecto
-- Si ln_resultado es 1 esta correcto 
declare lv_resultado varchar(1000);
declare ln_resultado int default 0;

-- Asignacion Local
set lv_numero_tarjeta=IFNULL(case when length(pv_numero_tarjeta)=0 then null else pv_numero_tarjeta end,'0');

-- Validacion de parametro ingresado
-- Validar ingreso de numeros
-- Validar ingreso de 16 digitos
-- ln_validacion = 0 cadena incorrecta
-- ln_validacion = 1 cadena correcta
set  ln_validacion=lv_numero_tarjeta REGEXP '^[0-9]{16}$';

/*Si es incorrecta indicar que no es valida*/
if ln_validacion=0 then
set pv_resultado=concat('Credit Card ',lv_numero_tarjeta,' is not valid.');
set pn_resultado=0;
else
/*Obtener el numero de caracteres*/
set ln_longitud_tarjeta=length(lv_numero_tarjeta);

set ln_contador=ln_longitud_tarjeta;
/* Doblar el valor de cada segundo digito iniciando por la derecha  */
l_recorre: LOOP
 

    IF ln_contador <=ln_longitud_tarjeta and ln_contador>=0 THEN
        
      set lv_caracter=SUBSTR(lv_numero_tarjeta,ln_contador,1);  
   

       if mod(ln_contador,2)=1 then
       set lv_cadena=concat(lv_cadena,CAST(lV_caracter AS SIGNED  INTEGER)*2);
       else
       set lv_cadena=concat(lv_cadena,lv_caracter);
       end if;
       SET ln_contador = ln_contador - 1;
        
      ITERATE l_recorre;
    END IF;
    LEAVE l_recorre;
  END LOOP l_recorre;
  
/*Sumar todos los digitos obtenidos*/
set ln_longitud_tarjeta=length(lv_cadena);
set ln_contador=ln_longitud_tarjeta;


l_suma: LOOP
  IF ln_contador <= ln_longitud_tarjeta and ln_contador>=1 THEN
  set lv_caracter=SUBSTR(lv_cadena,ln_contador,1);
  set ln_suma=ln_suma+CAST(lv_caracter AS SIGNED  INTEGER); 
       SET ln_contador = ln_contador - 1;
   ITERATE l_suma;
    END IF;
     LEAVE l_suma;
  END LOOP l_suma;
  
 /* Calcular el restante de la divicion sobre 10 e imprime el resultado*/
   IF mod(ln_suma,10) = 0 THEN
   set pv_resultado=concat('Credit Card ',pv_numero_tarjeta,' is valid.');
   set pn_resultado=1;
  else
   set pv_resultado=concat('Credit Card ',pv_numero_tarjeta ,' is not valid.');
   set pn_resultado=0;
  END IF; 
end if;
END