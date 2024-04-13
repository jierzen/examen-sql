psql -U postgres
CREATE DATABASE examen_sql;
\c examen_sql;


--1. Revisa el tipo de relación y crea el modelo correspondiente. 
-- Respeta las claves primarias, foráneas y tipos de datos. (1 punto)
CREATE TABLE TAG(
    id int primary key,
    tag varchar(255)
);

CREATE TABLE PELICULA(
    id int primary key,
    id_tag int,
    nombre varchar(255),
    anno int,
    FOREIGN KEY (id_tag) REFERENCES TAG(id) --agrego llave foranea
);

--2. Inserta 5 películas y 5 tags; la primera película debe tener 3 tags asociados, 
--la segunda película debe tener 2 tags asociados. (1 punto)

INSERT INTO TAG(id,tag) VALUES 
(1,'suspenso'),
(2,'sci-fi'),
(3,'comedia'),
(4,'accion'),
(5,'terror');

INSERT INTO PELICULA(id,id_tag,nombre,anno) VALUES
--1ra pelicula con 3 tags (comedia,accion y sci-fi)
(1,3,'This Is Spinal Tap',1984),
(2,4,'This Is Spinal Tap',1984),
(3,2,'This Is Spinal Tap',1984),

--2da pelicula con 2 tags (sci-fi y comedia)
(4,2,'Star Wars: The Empire Strikes Back',1980),
(5,3,'Star Wars: The Empire Strikes Back',1980),

(6,1,'The Prestige',2006), --suspenso
(7,1,'Air Force One',1997), --suspenso
(8,3,'Monty Python''s Life of Brian',1979); --comedia

--3. Cuenta la cantidad de tags que tiene cada película. 
-- Si una película no tiene tags debe mostrar 0. (1 punto)
SELECT 
    p.nombre AS "Pelicula", 
    COUNT(t.id) AS "Cantidad de Tags"
FROM PELICULA p
LEFT JOIN TAG t ON p.id_tag = t.id
GROUP BY p.nombre;


--=====================================================================

--4. Crea las tablas correspondientes respetando los nombres, tipos, claves primarias 
--y foráneas y tipos de datos. (1 punto)

CREATE TABLE PREGUNTAS(
    id int primary key,
    pregunta varchar(255),
    respuesta_correcta varchar

);

CREATE TABLE USUARIOS(
    id int primary key,
    nombre varchar(255),
    edad int
);

CREATE TABLE RESPUESTAS(
    id int primary key,
    respuesta varchar(255),
    usuario_id int,
    pregunta_id int,
    CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES USUARIOS(id),
    CONSTRAINT fk_pregunta FOREIGN KEY(pregunta_id) REFERENCES PREGUNTAS(id)
);

--Agrega 5usuarios y 5 preguntas.
--Contestada correctamente significa que la respuesta indicada en la tabla respuestas es exactamente 
--igual al texto indicado en la tabla de preguntas. (1 punto)

INSERT INTO PREGUNTAS(id,pregunta,respuesta_correcta) VALUES 
(1,'Si en una carrera adelantas a la persona que va segunda, ¿en qué posición estás?','Segundo'),
(2,'¿Qué tiene palabras, pero nunca habla?','Un libro'),
(3,'¿Qué sube, pero nunca baja?','La edad'),
(4,'¿Cuál es el día más largo de la semana?','El miércoles'),
(5,'¿Qué tiene cuello, pero no cabeza?','Una botella');

INSERT INTO USUARIOS(id,nombre,edad) VALUES
(1,'Alfredo',34),
(2,'Maria',21),
(3,'Juan',18),
(4,'Eduardo',27),
(5,'Loreto',56);

INSERT INTO RESPUESTAS(id,respuesta,usuario_id,pregunta_id) VALUES 
--a. (Juan y Loreto responden bien a la pregunta 1).
(1,'Segundo',3,1),
(2,'Segundo',5,1),
--b. (Maria responde bien la pregunta 2). 
(3,'Un libro',1,2),
--c. Respuestas incorrectas por parte de Maria, Loreto y Eduardo.
(4,'Un avion',2,3),
(5,'El lunes',5,4),
(6,'Un lapiz',4,5);

--6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta). (1 punto)
SELECT 
    u.nombre AS "Usuario",
    SUM(CASE WHEN p.respuesta_correcta = r.respuesta THEN 1 ELSE 0 END) AS "Cantidad Respuestas Correctas"
FROM USUARIOS u
LEFT JOIN RESPUESTAS r ON u.id = r.usuario_id
LEFT JOIN PREGUNTAS p ON r.pregunta_id = p.id
GROUP BY u.nombre;

--7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios respondieron correctamente. (1 punto)
SELECT 
    p.pregunta AS "Pregunta",
    SUM(CASE 
			WHEN p.respuesta_correcta = r.respuesta THEN 1 
			ELSE 0 
		END) AS "Respuestas Correctas"
FROM PREGUNTAS p 
LEFT JOIN RESPUESTAS r ON p.id = r.pregunta_id
GROUP BY p.pregunta;

--8. Implementa un borrado en cascada de las respuestas al borrar un usuario. 
--Prueba la implementación borrando el primer usuario. (1 punto)
ALTER TABLE RESPUESTAS DROP CONSTRAINT fk_usuario;

ALTER TABLE RESPUESTAS 
ADD CONSTRAINT fk_usuario 
FOREIGN KEY (usuario_id) 
REFERENCES USUARIOS(id) 
ON DELETE CASCADE;

DELETE FROM USUARIOS WHERE id = 1;


--9. Crea una restricción que impida insertar usuarios menores de 18 años en la
--base de datos. (1 punto)

ALTER TABLE USUARIOS 
ADD CONSTRAINT chk_mayor_edad
CHECK (edad >= 18);

--prueba 1
INSERT INTO USUARIOS(id,nombre,edad) VALUES 
(1,'Teresa',15);

--prueba 2
INSERT INTO USUARIOS(id,nombre,edad) VALUES 
(1,'Pedro',21);

--10. Altera la tabla existente de usuarios agregando el campo email. Debe tener 
--la restricción de ser único.

ALTER TABLE USUARIOS ADD email varchar(50);

ALTER TABLE USUARIOS
ADD CONSTRAINT uniq_email
UNIQUE(email);

--prueba 1
INSERT INTO USUARIOS(id,nombre,edad,email) VALUES 
(6,'Jose',23,'jose15@gmail.com');

--prueba 2
INSERT INTO USUARIOS(id,nombre,edad,email) VALUES 
(7,'Esteban',31,'jose15@gmail.com');