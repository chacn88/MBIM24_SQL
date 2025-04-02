------------------------------------------------------------------------------------------------
-- SELECT CON FUNCIONES
------------------------------------------------------------------------------------------------
/* 1
Mostrar la fecha actual de la siguiente forma:
Fecha actual
------------------------------
Sábado, 11 de febrero de 2027. 16:06:06

El día en palabras con la primera letra en mayúsculas, seguida de una coma, el día en números,
la palabra "de", el mes en minúscula en palabras, la palabra "de", el año en cuatro dígitos
finalizando con un punto. Luego la hora en formato 24h con minutos y segundos.
Y de etiqueta del campo "Fecha actual".
*/
Select 
concat(
rtrim(to_char(sysdate, 'Day, dd "de" Month')),
to_char (sysdate,' "de" yyyy. hh24:mm:ss'))
from dual;

/* 2
Día en palabras de cuando se instalaron los componentes
del facility 1
*/
SELECT 
    INITCAP(TO_CHAR(components.installatedOn, 'Day')) AS "Día de instalación",
    components.name AS "Componente"
FROM components
JOIN spaces ON components.spaceId = spaces.id
JOIN floors ON spaces.floorId = floors.id
JOIN facilities ON floors.facilityId = facilities.id
WHERE facilities.id = 1;
/* 3
De los espacios, obtener la suma de áreas, cuál es el mínimo, el máximo y la media de áreas
del floorid 1. Redondeado a dos dígitos.
*/
select count(netarea), sum(netarea), min(netarea), max(netarea), round(avg(netarea),2)
from spaces
where floorid =1;

/* 4
¿Cuántos componentes tienen espacio? ¿Cuántos componentes hay?
En el facility 1. Ej.
ConEspacio  Componentes
----------------------------
3500  4000
*/
select count(id), count(*), count(spaceid)
from components
where facilityid =1;

/* 5
Mostrar tres medias que llamaremos:
-Media a la media del área bruta
-MediaBaja la media entre el área media y el área mínima
-MediaAlta la media entre el área media y el área máxima
de los espacios del floorid 1
Solo la parte entera, sin decimales ni redondeo.
*/
SELECT 
    TRUNC(AVG(netarea)) AS Media, 
    TRUNC((AVG(netarea) + MIN(netarea)) / 2) AS MediaBaja, 
    TRUNC((AVG(netarea) + MAX(netarea)) / 2) AS MediaAlta  
FROM spaces
WHERE floorId = 1;
/* 6
Cuántos componentes hay, cuántos tienen fecha inicio de garantia, cuántos tienen espacio, y en cuántos espacios hay componentes
en el facility 1.
*/
select id
from floors
where facilityid =1;

select name
from spaces
where floorid in(1,2,3,4); /* el "in" sustituye a poner "or"*/

/* 7
Mostrar cuántos espacios tienen el texto 'Aula' en el nombre
del facility 1.
*/
SELECT COUNT(s.id) AS TotalAulas
FROM spaces s
JOIN floors f ON s.floorId = f.id
JOIN facilities fa ON f.facilityId = fa.id
WHERE fa.id = 1
AND LOWER(s.name) LIKE '%aula%';

/* 8
Mostrar el porcentaje de componentes que tienen fecha de inicio de garantía
del facility 1.
*/
select round(count(warrantystarton)*100/count(*),2) PCTTienenGarantia
from components
where facilityid =1;

/* 9
Listar las cuatro primeras letras del nombre de los espacios sin repetir
de la planta 1. 
En orden ascendente.
Ejemplo:
Aula
Area
Aseo
Pasi
Pati
Serv
*/
SELECT DISTINCT SUBSTR(name, 1, 4) AS NombreCorto
FROM spaces
WHERE floorId = 1
ORDER BY NombreCorto ASC;

/* 10
Número de componentes por fecha de instalación del facility 1
ordenados descendentemente por la fecha de instalación
Ejemplo:
Fecha   Componentes
-------------------
2021-03-23 34
2021-03-03 232
*/
SELECT 
    c.installatedOn AS FechaInstalacion, 
    COUNT(c.id) AS NumeroComponentes
FROM components c
JOIN spaces s ON c.spaceId = s.id
JOIN floors f ON s.floorId = f.id
JOIN facilities fa ON f.facilityId = fa.id
WHERE fa.id = 1
AND c.installatedOn IS NOT NULL
GROUP BY c.installatedOn
ORDER BY c.installatedOn DESC;
/* 11
Un listado por año del número de componentes instalados del facility 1
ordenados descendentemente por año.
Ejemplo
Año Componentes
---------------
2021 344
2020 2938
*/
SELECT 
    c.installatedOn AS FechaInstalacion, 
    COUNT(c.id) AS NumeroComponentes
FROM components c
JOIN spaces s ON c.spaceId = s.id
JOIN floors f ON s.floorId = f.id
JOIN facilities fa ON f.facilityId = fa.id
WHERE fa.id = 1
AND c.installatedOn IS NOT NULL
GROUP BY c.installatedOn
ORDER BY c.installatedOn DESC;
/* 12
Nombre del día de instalación y número de componentes del facility 1.
ordenado de lunes a domingo
Ejemplo:
Día         Componentes
-----------------------
Lunes    	503
Martes   	471
Miércoles	478
Jueves   	478
Viernes  	468
Sábado   	404
Domingo  	431
*/
select to_char(installatedon,'Day'),
count(id)
from components
where facilityid =1
group by to_char(installatedon,'Day'),
to_char(installatedon,'d') /* debemos agrupar aquellos "select" que NO tienen función cuando tenemos 
mínimo 1 select que SÍ tiene función */
order by to_char(installatedon,'d');

/*Aqui hacemos el mismo ejemplo pero diciendo que me arroje los mayores a 470,
para esto se usa "having" después de agrupar ya que no puedo tenerlo en el "where" porque primero debo agrupar*/
select to_char(installatedon,'Day'),
count(id)
from components
where facilityid =1
group by to_char(installatedon,'Day'),
to_char(installatedon,'d')
having count(id)>470
order by to_char(installatedon,'d');


/*13
Mostrar en base a los cuatro primeros caracteres del nombre cuántos espacios hay
del floorid 1 ordenados ascendentemente por el nombre.
Ejemplo.
Aula 23
Aseo 12
Pasi 4
*/
SELECT 
    SUBSTR(s.name, 1, 4) AS NombreCorto, 
    COUNT(s.id) AS NumeroEspacios
FROM spaces s
WHERE s.floorId = 1
GROUP BY SUBSTR(s.name, 1, 4)
ORDER BY NombreCorto ASC;

/*14
Cuántos componentes de instalaron un Jueves
en el facilityid 1
*/
select count(to_char(installatedon,'Day'))
from components
where facilityid =1
and to_char(installatedon,'Day') like '%Jueves%';

/*15
Listar el id de planta concatenado con un guión
seguido del id de espacio concatenado con un guión
y seguido del nombre del espacio.
el id del espacio debe tener una longitud de 3 caracteres
Ej. 3-004-Nombre
/* Sacar name de facilities, floors and spaces */
select facilities.name,
floors.name,
spaces.name
from spaces, floors, facilities
where floors.id = spaces.floorid and facilities.id = floors.facilityid; /*tenemos que relacionar las distintas tablas
para que no se me multipliquen todos por todos*/

/* Otra manera de escribirlo es usando "join" que sirve para relacionar las tablas*/
select facilities.name,
floors.name,
spaces.name
from floors
join spaces on floors.id = spaces.floorid
join facilities on facilities.id = floors.facilityid
where facilities.id =1;
 
------------------------------------------------------------------------------------------------
