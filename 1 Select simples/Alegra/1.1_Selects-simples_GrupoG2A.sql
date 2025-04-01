------------------------------------------------------------------------------------------------
--SELECTS SIMPLES
------------------------------------------------------------------------------------------------
/* 1
Describir la tabla floors
*/ 
desc floors;

/* 2
Describir la tabla spaces
*/
desc spaces;

/* 3
Datos de la tabla components
el asterisco quiere decir que selecciona "todo"*/
select *
from components;

/* 4
Datos de la tabla component_types
*/
select *
from component_types;

/* 5
Id, nombre de los facilities
*/
select id,name
from facilities;

/* 6
Nombre, elevación e id del facility de las plantas
*/
select name,elevation,facilityid
from floors;

/* 7
Nombre, area bruta, volumen de los espacios
*/
select name,grossarea,volume
from spaces;

/* 8
Nombre, vida útil de los tipos de componentes del facility 1
*/
select name,EXPECTEDLIFE,facilityid
from component_types
where facilityid=1;

/* 9
Nombre de los espacios de la Planta 1 del facility 1
*/
/*Previamente se consulta cuál es el floorid
listandolos... en where facilityid=1 and name='Planta +1' pude haber puesto where facilityid=1 and name like='%Planta%'... 
esto me muestra todo lo que contenga la palabra planta y así verifico que numero es mi planta que estoy buscando
también podría usar '_l%' esto significa que busco algo que en el segundo caracter tengo una l*/
select id,name
from floors
where facilityid=1 and name='Planta +1';
/*Esto fue parabuscar la planta 1, ya se que es 1 entonces ahora si programo la instrucción*/
select name, floorid
from spaces
where floorid = 1;

/* 10
Nombre, número de modelo del tipo de componente con id = 60
*/
select name, MODELNUMBER
from component_types
where id = 60;

/* 11
Nombre y fecha de instalación de los componentes del espacio 60 ordenados descendentemente por la fecha de instalación
*/
select name, INSTALLATEDON
from components
where spaceid=60
order by INSTALLATEDON desc;


/* 12
Listar las distintas fechas de instalación de los componentes del facility 1 ordenados descendentemente.
*/
select distinct INSTALLATEDON
from components
where FACILITYID=1
order by INSTALLATEDON desc;

/* 13
Listar los distintos GUIDs de los componentes del facility 1 ordenados ascendentemente por fecha de garantía.
*/
SELECT DISTINCT GUID
FROM Componentes
WHERE FacilityID = 1
ORDER BY FechaGarantia ASC;

/* 14
Id, código de activo, GUID, número de serie y nombre de los componentes cuyo spaceid está entre 10 y 27 inclusive
ordenados por id de espacio descendentemente.
*/
select id,assetidentifier,externalidentifier,serialnumber,name
from components
where spaceid between 10 and 27
order by spaceid desc;

/* 15
Id, código de activo, GUID, número de serie y nombre de los componentes del facility 1 
ordenados por código de activo descendentemente.
*/
select id,assetidentifier,externalidentifier,serialnumber,name
from components
where facilityid=1
order by assetidentifier desc;

/* 16
Códigos de activo de los componentes del espacio con id 21
ordenados por código de activo descendentemente.
*/
select assetidentifier
from components
where spaceid=21
order by assetidentifier desc;

/* 17
Las distintas fechas de instalación de los componentes 
de los espacios con id 10, 12, 16, 19 
ordenadas descendentemente.
*/
SELECT DISTINCT FechaInstalacion
FROM Componentes
WHERE SpaceID IN (10, 12, 16, 19)
ORDER BY FechaInstalacion DESC;
/* 18
Nombre, volumen, de los espacios
cuyo volumen es mayor a 90 de floorid = 1
ordenados por volumen descendentemente
*/
select name,volume
from spaces
where volume >90 and floorid=1
order by volume desc;

/* 19
Nombre, volumen de los espacios
cuyo volumen es mayor a 6 y menor a 9 de la planta con id = 1
*/
select name,volume
from spaces
where volume between 6 and 9 and id=1;

/* 20
Nombre, código de activo, número de serie de los componentes
que no tengan espacio del facility 1
ordenados descendentemente por código de activo
*/
select name,assetidentifier,serialnumber
from components 
where FACILITYID=1 and spaceid is null
order by assetidentifier desc;

/* 21
Nombre, código de activo, número de serie de los componentes
que tengan número de serie del facility 1
*/
select name,assetidentifier,serialnumber
from components 
where FACILITYID=1 and serialnumber is not null;


/* 22
Nombre de los espacios que empiezan por la letra A donde floorid = 1
*/
select name
from spaces 
where floorid=1 and name like 'A%';

/* 23
Lista de espacios que su segunda letra es una 's' donde floorid = 1
*/
select name
from spaces 
where floorid=1 and name like '_s%';
/*Aqui debemos cuidar mayusculas y minusculas de la "s", sino, podríamos usar
la función upper: upper(name) like '_s%' --> asi ya si no sabes si estan en mayus
o minus, ya agarras todo porque pasas todo a mayus con la funcion upper */

/* 24
Lista de tipos de componente del facility 1 
donde el nombre contiene el texto 'con'
y no tienen vida útil indicada o fecha de garantia 
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
AND Nombre LIKE '%con%'
AND (VidaUtil IS NULL OR FechaGarantia IS NULL);
/* 25
Nombres de espacios y volumen
pero como volumen una etiqueta que indique 
'BAJO' si es menor a 10, 'ALTO' si es mayor a 1000
y 'MEDIO' si está entre medias
*/
Select name noml,
volume,
case 
when volume < 10 then 'bajo'
when volume > 1000 then 'alto'
else 'medio'
end LABELVOLUME,
netarea
from spaces;


/* 26
Nombre, fecha de instalación, fecha de garantia
de los componentes del facility 1
que tienen fecha de garantia
*/
SELECT Nombre, FechaInstalacion, FechaGarantia
FROM Componentes
WHERE FacilityID = 1
  AND FechaGarantia IS NOT NULL;
/* 27
Lista de nombres de espacio que su id no es 4, 9, ni 19
del floorid 1
*/
Select name, id, floorid
from spaces
where floorid=1
and id != 4
and id != 9
and id != 19;

/* 28
Lista de espacios que no son Aula del floorid = 1
*/
Select name, floorid
from spaces
where floorid=1
and lower(name) not like '%aula%';
/*para prevenir que exista alguna palabra que antes de "aula"
tenga otra palabra podriamos poner: name not like '%Aula%' */

/* 29
Lista de los tipos de componentes que tienen duracion de la garantia de las partes
del facility 1
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
  AND DuracionGarantia IS NOT NULL;
/* 30
Lista de los tipos de componentes que no tiene el coste de repuesto
del facility 1
*/
SELECT DISTINCT TipoComponente
FROM Componentes
WHERE FacilityID = 1
  AND CosteRepuesto IS NULL;
/* 31
Lista de los tipos de componentes que tienen en el nombre un guión bajo
del facility 1
*/
Select name
from component_types
where facilityid=1
and lower(name) like '%$_%' escape '$';
/* al decirle la funcion "escape" le dices a la maquina que el guion bajo NO es 
un comodin, sino lo que busco. No necesariamente debe ser un $, puedo poner
cualquier caracter*/

--
------------------------------------------------------------------------------------------------
